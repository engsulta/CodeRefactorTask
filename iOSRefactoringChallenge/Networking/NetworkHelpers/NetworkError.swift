
import Foundation

enum NetworkError: String, Error{
    case missingURL = "missing URL"
    case faildToDecode = "unable to decode the response"
    case noNetwork = "unknown"
}


struct Constants {
    static let baseURL: String =  "https://api.soundcloud.com"
    static let clientId: String = "i71BoBoxTxlbVYvnt7O2reL86DynpqT3"
    static let clientSecret: String = "Mh6G90LOOuz1Vd04gBsNQMmHFwocWUzk"
    static let timeOut: TimeInterval = 30.0
    static let playlistId: String = "79670980"
}
