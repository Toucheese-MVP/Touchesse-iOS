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
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
    
    private enum CodingKeys: String, CodingKey {
        case studio = "content"
        case pageable, totalPages, totalElements, last, size, number, numberOfElements, first, empty
    }
}

struct TempStudio: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let profileImage: String
    let rating: Double
    let price: Int
    let imageUrls: [String]
}

extension TempStudio {
    var profileImageUrl: URL {
        URL(string: profileImage ) ?? .defaultImageURL
    }
    
    var profileImageUrls: [URL] {
        imageUrls.map { string in
            URL(string: string ) ?? .defaultImageURL
        }
    }
    
    var formattedRating: String {
        return String(format: "%.1f", rating)
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
//    let sort: StudioPageSort
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}

struct StudioPageSort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

