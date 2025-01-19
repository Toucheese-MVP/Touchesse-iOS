//
//  StudioDetailEntity.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/16/25.
//

import Foundation

struct StudioDetailEntity: Decodable {
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
    //TODO: 현재 시간이 영업 시간 내에 포함되는지
    var isOpen: Bool {
        let currentDayOfWeek = Date().dayWeek
        let currentComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        guard let currentTime = Calendar.current.date(from: currentComponents) else { return false }
        
        for hour in operatingHours {
            guard hour.dayOfWeek == currentDayOfWeek,
                  let openTime = hour.openTime.toDate(dateFormat: .hourMinute),
                  let closeTime = hour.closeTime.toDate(dateFormat: .hourMinute) else { return false }
            
            if currentTime >= openTime && currentTime <= closeTime {
                return true
            } else {
                return false
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
