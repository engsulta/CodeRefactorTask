//
//  FeatureRepository.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation
import RxSwift

protocol FeatureRepositoryProtocol {
    func getResponseModel(for params: RequestValues) -> Single<Decodable>?
}

class FeatureRepository: FeatureRepositoryProtocol {

    //private var dataSources: [DataSourceProtocol]?
    private var remoteDataSource: FeatureDataSourceProtocol?
    private var localDataSource: FeatureDataSourceProtocol?

    init(remoteDataSource: FeatureDataSourceProtocol,
         localDataSource: FeatureDataSourceProtocol) {

          self.remoteDataSource = remoteDataSource
          self.localDataSource = localDataSource
      }

    func getResponseModel(for params: RequestValues) -> Single<Decodable>? {
       return remoteDataSource?.getResponseModel(for: params)?.do(onSuccess: { model in
        if let model = model as? ResponseModel {
            _ = self.localDataSource?.saveModel(model)
        }
       // self.localDataSource?.save(model as! ResponseModel)

       })
    }
    //retrieving remote data and persisting it locally for offline mode, or any number of other common scenarios that nontrivial apps encounter.
}
