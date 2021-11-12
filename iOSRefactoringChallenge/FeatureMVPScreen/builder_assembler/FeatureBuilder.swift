//
//  FeatureBuilder.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 07/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import UIKit

protocol Assembler {
    func resolve() -> UIViewController?
}

class FeatureAssembler: Assembler {
    func resolve() -> UIViewController? {
        let vc = UIStoryboard(name: "Feature", bundle: nil).instantiateViewController(identifier: "FeatureViewController") as! FeatureViewController
//        let vc = FeatureViewController(nibName: String(describing: FeatureViewController.self),
//                                       bundle: nil)
        vc.presenter = resolve(ui: vc,useCase: resolve())
        return vc
    }
    func resolve(ui: FeatureUI,
                 useCase: FeatureUseCase) -> FeaturePresenter {
        MyFeaturePresenter(ui: ui, useCase: useCase)
    }
    func resolve() -> FeatureUseCase {
        FeatureUseCase(repository: resolve())
    }
    func resolve() -> FeatureRepository {
        FeatureRepository(remoteDataSource: resolve(), localDataSource: resolve())
    }
    func resolve() -> FeatureDataSourceProtocol {
        return FeatureRemoteDataSource()
    }
}

func globalTestCall() {
    let featAssembler: Assembler = FeatureAssembler()
    let vc = featAssembler.resolve()
}
