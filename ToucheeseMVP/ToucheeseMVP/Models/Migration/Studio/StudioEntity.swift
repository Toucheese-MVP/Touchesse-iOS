//
//  StudioEntity.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/13/25.
//

import Foundation

struct StudioEntity: Codable {
    let studio: [TempStudio]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: StudioPageSort
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
    
    private enum CodingKeys: String, CodingKey {
        case studio = "content"
        case pageable, totalPages, totalElements, last, size, number, sort, numberOfElements, first, empty
    }
}

struct TempStudio: Codable {
    let id: Int
    let name: String
    let profileImage: String
    let rating: Double
    let price: Int
    let imageUrls: [String]
}

// 이미지 String 배열을 URL 배열 타입으로 리턴
extension TempStudio {
    var profileImageUrls: [URL] {
        imageUrls.map { string in
            URL(string: string ) ?? .defaultImageURL
        }
    }
}

// 샘플
extension TempStudio {
    static let sample = TempStudio(
        id: 1,
        name: "마루 스튜디오",
        profileImage: "https://imgur.com/YJaYOeA.png",
        rating: 3.2,
        price: 99000,
        imageUrls: ["https://imgur.com/YJaYOeA.png", "https://imgur.com/YJaYOeA.png"]
    )
}

struct Pageable: Codable {
    let pageNumber: Int
    let pageSize: Int
    let sort: StudioPageSort
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}

struct StudioPageSort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

