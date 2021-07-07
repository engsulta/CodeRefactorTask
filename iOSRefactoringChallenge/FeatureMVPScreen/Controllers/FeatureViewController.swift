//
//  FeatureViewController.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import UIKit
protocol FeatureUI: AnyObject {
// the ui method that will be used from the presenter to update this part in ui
    func showProducts(responseModel: ResponseModel)
    func showError()
}

class FeatureViewController: UIViewController {

    var presenter: FeaturePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.getResponseModel(for: GetCatalogProductsRequestValues(catalogId: "id"))

    }

}

extension FeatureViewController: FeatureUI {
    func showProducts(responseModel: ResponseModel) {
        //
    }

    func showError() {
        //
    }


}
