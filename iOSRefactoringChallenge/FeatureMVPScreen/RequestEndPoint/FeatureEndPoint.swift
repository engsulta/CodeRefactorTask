//
//  FeatureEndPoint.swift
//  iOSRefactoringChallenge
//
//  Created by Ahmed Sultan on 06/07/2021.
//  Copyright © 2021 SoundCloud. All rights reserved.
//

import Foundation

enum FeatureEndPoint: EndPointProtocol {
    case point1(params: RequestValues) //

    case point2

    var path: String? {
        return "/feature"
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var httpParameters: [String : String]? {
        return nil
    }

    var headers: [String : String]? {
        return nil
    }

    var timeout: TimeInterval {
        return 30.0
    }

    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringLocalCacheData
    }
}

protocol RequestValues {
    var parameters: [String: Any] { get }
}
class GetCatalogProductsRequestValues: RequestValues {
    var parameters:  [String: Any] {
        ["catalogId": catalogId]
    }

    let catalogId: String
    public init(catalogId: String) {
        self.catalogId = catalogId
    }
}
