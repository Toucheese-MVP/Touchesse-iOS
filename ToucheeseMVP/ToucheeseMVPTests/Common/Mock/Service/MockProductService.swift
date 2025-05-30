//
//  MockProductService.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 5/27/25.
//

import Foundation
@testable import ToucheeseMVP

final class MockProductService: ProductService {
    var groupOptionStub: GroupOptionEntity = GroupOptionEntity(isGroup: 0, pricePerPerson: 0)
    
    func getProductDetail(productId: Int) async throws -> ToucheeseMVP.ProductDetailEntity {
        return ProductDetailEntity(
            id: 1,
            name: "MockProductDetail",
            description: "ProductDetail의 Mock 객체입니다.",
            productImage: "",
            reviewCount: 0,
            standard: 1,
            price: 0,
            addOptions: [],
            groupOption: groupOptionStub
        )
    }
}
