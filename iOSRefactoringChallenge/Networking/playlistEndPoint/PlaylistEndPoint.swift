import Foundation

///  End-point representation for playlist EndPoint
enum PlaylistEndPoint: EndPointProtocol {
    // all paths for this endpoint
    case playlist(playlistId: String)
    case futureUse

    var httpMethod: HTTPMethod {
        switch self {
        case .playlist:
            return .get
        case .futureUse:
            return .post
        }
    }

    var path: String? {
        switch self {
        case let .playlist(playlistId):
            return "/playlists/\(playlistId)"
        case .futureUse:
            return "/futureUse"
        }
    }

    var httpParameters: [String: String]? {
        switch self {
        case .playlist:
            return ["client_id": Constants.clientId, "client_secret": Constants.clientSecret]
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var timeout: TimeInterval { Constants.timeOut }

    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }
}
