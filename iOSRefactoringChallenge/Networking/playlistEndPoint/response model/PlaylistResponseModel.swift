

import Foundation

struct PlayListResponseModel: Codable {
    let tracks: [Track]?
}

struct Track: Codable {
    var trackId: Int64?
    var trackTitle: String?
    enum CodingKeys: String, CodingKey {
        case trackTitle = "title"
        case trackId = "id"
    }
}
