//
//  Feat2Builder.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 07/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import UIKit

class Feature2Assembler: Assembler {
    func resolve() -> UIViewController? {
        let vc = UIStoryboard(name: "Feature2", bundle: nil).instantiateViewController(identifier: "Feature2ViewController") as! Feature2ViewController
//        let vc = FeatureViewController(nibName: String(describing: FeatureViewController.self),
//                                       bundle: nil)
        vc.viewModel = resolve(useCase: resolve())
        return vc
    }
    func resolve(useCase: FeatureUseCase) -> FeatureViewModel {
        MyFeatureViewModel(useCase: useCase)
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

func globalCall() {
    let featAssembler: Assembler = FeatureAssembler()
    let vc = featAssembler.resolve()
}
