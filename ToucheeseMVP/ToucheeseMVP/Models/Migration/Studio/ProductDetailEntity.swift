//
//  ProductDetailEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 1/20/25.
//

import Foundation

struct ProductDetailEntity: Decodable {
    let id: Int
    let name: String
    let description: String
    let productImage: String
    let reviewCount: Int
    let standard: Int
    let price: Int
    let addOptions: [OptionEntity]
}

struct OptionEntity: Decodable {
    let id: Int
    let price: Int
    let name: String
}
