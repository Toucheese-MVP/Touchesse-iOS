//
//  Product.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let description: String
    let imageString: String
    let price: Int
    let reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageString, price
        case reviewCount = "reviewCnt"
    }
}


struct ProductDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ProductDetail
}


struct ProductDetail: Codable {
    let isGroup: Bool
    let basePeopleCnt: Int?
    let addPeoplePrice: Int?
    
    let productOptions: [String]
}


struct ProductOption: Identifiable, Codable {
    let id: Int
    let name: String
    let price: Int
}


extension Product {
    static let sample1 = Product(
        id: 1,
        name: "상품 이름",
        description: "상품에 대한 설명이 표시 됩니다.",
        imageString: "https://imgur.com/oKoO2ca.png",
        price: 0,
        reviewCount: 0
    )
    
    static let sample2 = Product(
        id: 2,
        name: "상품 이름",
        description: "상품에 대한 설명이 표시 됩니다.",
        imageString: "https://imgur.com/oKoO2ca.png",
        price: 0,
        reviewCount: 0
    )
    
    static let sample3 = Product(
        id: 3,
        name: "상품 이름",
        description: "상품에 대한 설명이 표시 됩니다.",
        imageString: "https://imgur.com/oKoO2ca.png",
        price: 0,
        reviewCount: 0
    )
    
    var imageURL: URL {
        URL(string: imageString) ?? .defaultImageURL
    }
}


extension ProductDetail {
    static let sample1 = ProductDetail(
        isGroup: false,
        basePeopleCnt: 4,
        addPeoplePrice: 25000,
        productOptions: []
    )
    
    static let sample2 = ProductDetail(
        isGroup: false,
        basePeopleCnt: 4,
        addPeoplePrice: 25000,
        productOptions: ["셀프촬영추가:50000", "필터:7000", "혈색:3000"]
    )
    
    var parsedProductOptions: [ProductOption] {
        var currentID = 0
        return productOptions.compactMap { optionString in
            let components = optionString.split(separator: ":").map { String($0) }
            
            // "name:price" 형식으로 파싱
            guard components.count == 2, let price = Int(components[1]) else {
                return nil
            }
            
            let option = ProductOption(id: currentID, name: components[0], price: price)
            currentID += 1
            return option
        }
    }
}


extension ProductOption {
    static let sample1 = ProductOption(
        id: 1,
        name: "보정 사진 추가",
        price: 30000
    )
    
    static let sample2 = ProductOption(
        id: 2,
        name: "원본 전체 받기",
        price: 10000
    )
    
    static let sample3 = ProductOption(
        id: 3,
        name: "액자 프린팅",
        price: 15000
    )
}
