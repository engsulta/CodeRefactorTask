//
//  FeatureViewController.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import UIKit

class Feature2ViewController: UIViewController {

    var viewModel: FeatureViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initVM() {

        viewModel?.showError?.asObservable()
            .subscribe(onNext: { error in
                // show error
            }).disposed(by: viewModel!.disposeBag)


        viewModel?.showProducts?.asObservable()
            .subscribe(onNext: { model in
                // show products
            }).disposed(by: viewModel!.disposeBag)

        // request models
        viewModel?.getResponseModel(for: GetCatalogProductsRequestValues(catalogId: "id"))
    }
}
