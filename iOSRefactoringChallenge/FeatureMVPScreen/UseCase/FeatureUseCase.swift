//
//  FeatureUseCase.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation
import RxSwift

protocol UseCase {
    associatedtype T
    associatedtype Q
    func execute(for params: Q) -> Single<T>?
}

class FeatureUseCase: UseCase {

    typealias T = Decodable
    typealias Q = RequestValues
    private let repository: FeatureRepositoryProtocol?
    init(repository: FeatureRepositoryProtocol?) {
        self.repository = repository
    }

    func execute(for params: Q) -> Single<T>? {
        return repository?.getResponseModel(for: params)
    }

}
