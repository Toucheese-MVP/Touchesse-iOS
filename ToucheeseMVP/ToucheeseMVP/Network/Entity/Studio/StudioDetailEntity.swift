//
//  StudioDetailEntity.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/16/25.
//

import Foundation

struct StudioDetailEntity: Decodable, Hashable {
    let id: Int
    let name: String
    let profileImage: String
    let rating: Double
    let reviewCount: Int
    let address: String
    let notice: String
    let facilityImageUrls: [String]
    let products: [ProductEntity]
    let operatingHours: [OperatingHour]
}

struct ProductEntity: Decodable, Hashable {
    let id: Int
    let name: String
    let description: String
    let productImage: String
    let reviewCount: Int
    let standard: Int
    let price: Int
}

struct OperatingHour: Decodable, Hashable {
    let dayOfWeek: String
    let openTime: String
    let closeTime: String
}

extension StudioDetailEntity {
    // 이게 view가 appear될때마다 호출돼서 계산이 되는데.. 이게 맞나 싶습니다!
    var isOpen: Bool {
        let currentWeekDay = Date().dayWeek

        guard let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour else { return false }

        for hour in operatingHours {
            if hour.dayOfWeek == currentWeekDay {
                guard let openTime = Int(hour.openTime.split(separator: ":").first!),
                let closeTime = Int(hour.closeTime.split(separator: ":").first!) else { return false }
                
                if currentHour >= openTime && currentHour <= closeTime {
                    return true
                }
            } else {
                continue
            }
        }
        return false
    }
    
    static let sample = StudioDetailEntity(
        id: 1,
        name: "",
        profileImage: "https://imgur.com/YJaYOeA.png",
        rating: 0.0,
        reviewCount: 0,
        address: "",
        notice: "",
        facilityImageUrls: ["https://imgur.com/YJaYOeA.png"],
        products: [ProductEntity(
            id: 1,
            name: "",
            description: "",
            productImage: "https://imgur.com/YJaYOeA.png",
            reviewCount: 0,
            standard: 0,
            price: 0
        )],
        operatingHours: [OperatingHour(
            dayOfWeek: "",
            openTime: "",
            closeTime: ""
        )]
    )
}

extension ProductEntity {
    static let sample = ProductEntity(
        id: 1,
        name: "",
        description: "",
        productImage: "",
        reviewCount: 0,
        standard: 0,
        price: 0
    )
}
