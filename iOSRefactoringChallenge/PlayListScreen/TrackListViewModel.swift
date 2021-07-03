import Foundation
import RxSwift
import RxCocoa
protocol TrackListViewModelProtocol {
    var provider: NetworkClient { get }
    var tracks: [Track] { get set }
    var loadingErrorClosure: (() -> Void)? { get set }
    
    func fetchTracks(completion: (([Track]) -> Void)?)
    func trackTitle(for indexPath: IndexPath) -> String
}

struct TrackListViewModel: TrackListViewModelProtocol {
    var provider: NetworkClient = NetworkClient(baseURL: Constants.baseURL)
    var tracks: [Track] = []
    var loadingErrorClosure: (() -> Void)?
    let disposeBag: DisposeBag = DisposeBag()

    func fetchTracks(completion: (([Track]) -> Void)?) {
        provider
            .rx
            .request(PlaylistEndPoint.playlist(playlistId: Constants.playlistId), model: PlayListResponseModel.self)
            .asObservable()
            .subscribe({
                event in
                switch event {
                case .next(let model):
                    guard
                          let tracks = (model as? PlayListResponseModel)?.tracks else {
                        completion?([])
                        loadingErrorClosure?()
                        return
                    }
                    completion?(tracks)
                case .error(let error):
                    print("error \(error.localizedDescription)")
                    loadingErrorClosure?()
                case .completed:
                    print("completed")
                }
            }).disposed(by: disposeBag)
    }

    func trackTitle(for indexPath: IndexPath) -> String {
        guard tracks.count > indexPath.row else { return "" }
        return tracks[indexPath.row].trackTitle ?? ""
    }
}
