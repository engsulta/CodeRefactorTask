//
//  FeaturePresenter.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol Presenter {
    func bind()
    var disposeBag: DisposeBag { get }
    var loadingBehavioralRelay: BehaviorRelay<Bool>? { get }
}

protocol FeaturePresenter: Presenter {
    func getResponseModel(for params: RequestValues)
}

class MyFeaturePresenter: FeaturePresenter {

    var disposeBag: DisposeBag = DisposeBag()
    var loadingBehavioralRelay: BehaviorRelay<Bool>? = BehaviorRelay<Bool>(value: false)
    var useCase: FeatureUseCase?
    weak var ui: FeatureUI?
//    var requestModel: RequestValues

    init(ui: FeatureUI,
         useCase: FeatureUseCase) {
        self.ui = ui
        self.useCase = useCase
//        self.requestModel = requestModel
    }

    func bind() {
        // start basic logic for presenter here
    }

    func getResponseModel(for params: RequestValues) {
        loadingBehavioralRelay?.accept(true)
        useCase?.getResponseModel(for: params)?
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                self?.loadingBehavioralRelay?.accept(false)
            guard let products = model as? ResponseModel else { return }
                self?.ui?.showProducts(responseModel: products)
        }, onError: { [weak self] error in
            self?.loadingBehavioralRelay?.accept(false)
            self?.ui?.showError()
        }).disposed(by: disposeBag)
    }
}
