//
//  ProductDetailEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 1/20/25.
//

import Foundation

struct ProductDetailEntity: Decodable, Hashable {
    let id: Int
    let name: String
    let description: String
    let productImage: String
    let reviewCount: Int
    let standard: Int
    let price: Int
    let addOptions: [OptionEntity]
    // let plusOptionInfo: GroupOptionEntity
    let groupOption: GroupOptionEntity
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, productImage, reviewCount, standard, price, addOptions
        case groupOption = "plusOptionInfo"
    }
}

struct OptionEntity: Decodable, Hashable {
    let id: Int
    let price: Int
    let name: String
}

struct GroupOptionEntity: Decodable, Hashable {
    let isGroup: Int
    let pricePerPerson: Int
    
    enum CodingKeys: String, CodingKey {
        case isGroup = "isPlusOpt"
        case pricePerPerson = "plusOptPrice"
    }
}

extension ProductDetailEntity {
    static let sample1 = ProductDetailEntity(
        id: 1,
        name: "상품 예시",
        description: "상품 설명 예시",
        productImage: "",
        reviewCount: 1,
        standard: 1,
        price: 10000,
        addOptions: [
            .init(id: 1, price: 3000, name: "옵션1"),
            .init(id: 2, price: 4000, name: "옵션2"),
        ],
        groupOption: GroupOptionEntity(
            isGroup: 0,
            pricePerPerson: 0
        )
    )
    static let sample2Group = ProductDetailEntity(
        id: 1,
        name: "상품 예시",
        description: "상품 설명 예시",
        productImage: "",
        reviewCount: 1,
        standard: 1,
        price: 10000,
        addOptions: [
            .init(id: 1, price: 3000, name: "옵션1"),
            .init(id: 2, price: 4000, name: "옵션2"),
        ],
        groupOption: GroupOptionEntity(
            isGroup: 1,
            pricePerPerson: 22000
        )
    )
}
