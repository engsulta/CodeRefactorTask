
import Foundation
protocol EndPointProtocol {
    /// The relative Endpoint path
    var path: String? { get }
    /// The HTTP request method
    var httpMethod: HTTPMethod { get }
    /// The HTTP request query params
    var httpParameters: [String: String]? { get }
    /// A dictionary containing all the request’s HTTP header fields related to such endPoint(default: nil)
    var headers: [String: String]? { get }
    /// timeout for each endpoint
    var timeout: TimeInterval { get }
    /// cachePolicy for each endpoint
    var cachePolicy: URLRequest.CachePolicy { get }
    /// each endpoint can change the default implementation for this method
    func buildRequest(for baseUrl: URL) throws -> URLRequest
}

extension EndPointProtocol {
    func buildRequest(for baseUrl: URL) throws -> URLRequest {
        var request = URLRequest(
            url: baseUrl.appendingPathComponent(path ?? ""),
            cachePolicy: cachePolicy,
            timeoutInterval: timeout)

        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        JSONParamEncoder().encode(urlRequest: &request, parameters: httpParameters)
        return request
    }
}

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
}
