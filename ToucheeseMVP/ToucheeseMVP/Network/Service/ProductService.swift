//
//  ProductService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

protocol ProductService {
    func getProductDetail(productId: Int) async throws -> ProductDetailEntity
}

final class DefaultProductService: BaseService { }

extension DefaultProductService: ProductService {
    func getProductDetail(productId: Int) async throws -> ProductDetailEntity {
        let fetchRequest = ProductAPI.productDetail(productId: productId)
        let result = try await performRequest(fetchRequest, decodingType: ProductDetailEntity.self)
        print("get product api call!!!")
        return result
    }
}
