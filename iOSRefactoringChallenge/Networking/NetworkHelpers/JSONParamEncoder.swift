
import Foundation

struct JSONParamEncoder {
    func encode(urlRequest: inout URLRequest,
                parameters: [String: String]?) {
        guard let parameters = parameters,
              let url = urlRequest.url,
              var urlComponents = URLComponents(url: url,resolvingAgainstBaseURL: false),
              !parameters.isEmpty else {
            return
        }
        urlComponents.setQueryItems(with: parameters)
        urlRequest.url = urlComponents.url
//        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
    }
}

