//
//  ProductAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum ProductAPI {
    /// 상품 상세 데이터 요청
    case productDetail(productId: Int)
}

extension ProductAPI: TargetType {
    
    static var apiType: APIType = .product
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .productDetail(let productId):
            return "/\(productId)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .productDetail:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .productDetail:
            HeaderType.json.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .productDetail:
            EncodingType.get.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .productDetail:
            return [:]
        }
    }
}
