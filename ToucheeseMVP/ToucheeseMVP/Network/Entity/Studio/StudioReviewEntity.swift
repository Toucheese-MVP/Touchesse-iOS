//
//  StudioReviewEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/25/25.
//

import Foundation

struct StudioReviewEntity: Decodable, Hashable {
    let id: Int
    let firstImage: String
}

struct ReviewDetailEntity: Decodable {
    let id: Int
    let content: String
    let rating: Float
    let reviewImages: [String]
}
