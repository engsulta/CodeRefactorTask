import Foundation

protocol TrackListViewModelProtocol {
    var provider: NetworkClientProtocol { get }
    var tracks: [Track] { get set }
    var loadingErrorClosure: (() -> Void)? { get set }
    
    func fetchTracks(completion: (([Track]) -> Void)?)
    func trackTitle(for indexPath: IndexPath) -> String
}

struct TrackListViewModel: TrackListViewModelProtocol {
    var provider: NetworkClientProtocol = NetworkClient(baseURL: Constants.baseURL)
    var tracks: [Track] = []
    var loadingErrorClosure: (() -> Void)?

    func fetchTracks(completion: (([Track]) -> Void)?) {
        provider.fetch(endPoint: PlaylistEndPoint.playlist(playlistId: Constants.playlistId),
                       model: PlayListResponseModel.self) { response, error in
            guard error == nil,
                  let tracks = (response as? PlayListResponseModel)?.tracks else {
                completion?([])
                loadingErrorClosure?()
                return
            }
            completion?(tracks)
        }
    }

    func trackTitle(for indexPath: IndexPath) -> String {
        guard tracks.count > indexPath.row else { return "" }
        return tracks[indexPath.row].trackTitle ?? ""
    }
}
