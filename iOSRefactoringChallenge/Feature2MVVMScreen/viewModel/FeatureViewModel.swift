//
//  FeatureViewModel.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
enum Response<T,Q> {

    case success(_ model: T)
    case failure(_ error: Q)
}
protocol ViewModel {
    func bind()
    var disposeBag: DisposeBag { get }
    var loadingBehavioralRelay: BehaviorRelay<Bool>? { get }
}
protocol FeatureViewModel: ViewModel {
    var showProducts: BehaviorRelay<ResponseModel>? { get }
    var showError: BehaviorRelay<Error>? { get }
    @discardableResult
    func getResponseModel(for params: RequestValues) -> Single<Decodable>?

}
class MyFeatureViewModel: FeatureViewModel {

    var disposeBag: DisposeBag = DisposeBag()
    var loadingBehavioralRelay: BehaviorRelay<Bool>? = BehaviorRelay<Bool>(value: false)
    var useCase: FeatureUseCase?
//    var showProducts: ((ResponseModel) -> Void)?
//    var showError: (() -> Void)?
    var showProducts: BehaviorRelay<ResponseModel>?
    var showError: BehaviorRelay<Error>?

    init(useCase: FeatureUseCase) {
        self.useCase = useCase
    }

    func bind() {
        // start basic logic for presenter here
    }

    func getResponseModel(for params: RequestValues) -> Single<Decodable>? {
        loadingBehavioralRelay?.accept(true)
        return useCase?.getResponseModel(for: params)
//        useCase?.getResponseModel(for: params)?
//            .asObservable()
//            .subscribe(onNext: { [weak self] model in
//                self?.loadingBehavioralRelay?.accept(false)
//            guard let products = model as? ResponseModel else { return }
//                // do some filteration and ui mapping on products to be fit for the ui
//                self?.showProducts?.accept(products)
//        }, onError: { [weak self] error in
//            self?.loadingBehavioralRelay?.accept(false)
//            self?.showError?.accept(error)
//        }).disposed(by: disposeBag)
//       return nil
    }
}
