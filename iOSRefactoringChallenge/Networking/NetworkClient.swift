import Foundation
typealias NetworkCompletion = (_ response: Decodable?, _ error: NetworkError?) -> Void

/// protocol for client api
protocol NetworkClientProtocol {
    var session: URLSessionProtocol { get }
    var baseURL: String { get }
    @discardableResult
    func fetch<T: Decodable>(endPoint: EndPointProtocol,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable?
}

/// concrete implementation for the client protocol
class NetworkClient: NetworkClientProtocol {
    var baseURL: String
    var session: URLSessionProtocol

    init(baseURL: String,
         session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
}

// MARK: - fetch implementation
extension NetworkClientProtocol {
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
