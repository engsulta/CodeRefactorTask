//
//  TrackListViewModel.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 23/04/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation

struct TrackListViewModel {
    var provider: NetworkManagerProtocol = NetworkClient(baseURL: Constants.baseURL)
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

    func numberOfTracks() -> Int {
        return tracks.count
    }

    func trackTitle(for indexPath: IndexPath) -> String {
        guard tracks.count > indexPath.row else { return "" }
        return tracks[indexPath.row].trackTitle ?? ""
    }
}
