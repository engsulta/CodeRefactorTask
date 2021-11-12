//
//  FeatureDataSource.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation
import RxSwift
/*
protocol DataSourceProtocol {

    func getResponseModel(for params: RequestValues) -> Single<Decodable>?
}
 */
// or


protocol FeatureDataSourceProtocol {

    func getResponseModel(for params: RequestValues) -> Single<Decodable>?

    @discardableResult
    func saveModel(_ model: ResponseModel) -> Single<Bool>?
}
extension FeatureDataSourceProtocol {
    func saveModel(_ model: ResponseModel) -> Single<Bool>? {
        return nil
    }
}

struct FeatureRemoteDataSource: FeatureDataSourceProtocol {
    var service: NetworkClient?

    func getResponseModel(for params: RequestValues) -> Single<Decodable>? {
        let endpoint = FeatureEndPoint.point1(params: params)
       return service?.rx.request(endpoint,
                                  model: ResponseModel.self)
    }

}

struct FeatureLocalDataSource: FeatureDataSourceProtocol {
    //var service: CoreDataMangerProtocol?
    var service: NetworkClient?

    func getResponseModel(for params: RequestValues) -> Single<Decodable>? {
        let endpoint = FeatureEndPoint.point1(params: params)
       return service?.rx.request(endpoint,
                                  model: ResponseModel.self)

    }
    func saveModel(_ model: ResponseModel) -> Single<Bool>? {
        // save in DB
        return Single.just(true)
    }
}
