import Foundation
import RxSwift
typealias NetworkCompletion = (_ response: Decodable?, _ error: NetworkError?) -> Void
typealias NetworkDataCompletion<T: Decodable> = (_ result: Result<T,Error>) -> Void


extension Reactive where Base: NetworkClient {
    func request<T: Decodable>(_ endPoint: EndPointProtocol, model: T.Type) -> Single<Decodable> {
        return Single.create { [weak base] single in
//            let cancellable = base?.fetch(endPoint: endPoint, model: model) { result in
//                switch result {
//                case let .success(response):
//                    single(.success(response))
//                case let .failure(error):
//                    single(.failure(error))
//                }
//            }
            let cancellable = base?.fetch(endPoint: endPoint, model: model) { model, error in
                if let model = model , error == nil {
                    single(.success(model))
                }else if let error = error {
                    single(.failure(error))
                }
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
}



/// protocol for client api
protocol NetworkClientProtocol: AnyObject {
    var session: URLSessionProtocol { get }
    var baseURL: String { get }
    @discardableResult
    func fetch<T: Decodable>(endPoint: EndPointProtocol,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable?
    func fetchData<T: Decodable>(endPoint: EndPointProtocol,
                            model: T.Type,
                            completion: @escaping NetworkDataCompletion<T>) -> Cancellable?
}

/// concrete implementation for the client protocol
final class NetworkClient: NetworkClientProtocol,ReactiveCompatible {

    let baseURL: String
    let session: URLSessionProtocol

    init(baseURL: String,
         session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
}

// MARK: - fetch implementation
extension NetworkClientProtocol {
    func fetchData<T: Decodable>(endPoint: EndPointProtocol,
                  model: T.Type,
                  completion: @escaping NetworkDataCompletion<T>) -> Cancellable? {
        fetch(endPoint: endPoint, model: model) { model, error in
            if let _ = error {
                completion(.failure(NetworkError.missingURL))
            }else {
                completion(.success(model as! T))
            }
        }
    }
    @discardableResult
    func fetch<T: Decodable>(endPoint: EndPointProtocol,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable? {
        guard let url = URL(string: baseURL),
              let urlRequest = try? endPoint.buildRequest(for: url) else {
            DispatchQueue.main.async {
                completion(nil, NetworkError.missingURL)
            }
            return nil
        }
        let currentTask =
            session.dataTask(with: urlRequest) { data, response, error in
                print("[LOG] response: \(String(describing: response))")
                guard let jsonData = data else {
                    DispatchQueue.main.async {
                        completion(nil, NetworkError.noNetwork)
                        print("[LOG] error from api \(NetworkError.noNetwork.rawValue)")
                    }
                    return
                }
                do {
                    let responseModel = try JSONDecoder().decode(model, from: jsonData)
                    DispatchQueue.main.async {
                        completion(responseModel, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, NetworkError.faildToDecode)
                        print("[LOG] error from api \(NetworkError.faildToDecode.rawValue)")
                    }
                }
            }
        currentTask.resume()
        return currentTask
    }
}
