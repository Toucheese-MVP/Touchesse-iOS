//
//  Review.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/26/24.
//

import Foundation

struct ReviewData: Codable {
    let totalPagesCount, pageNumber: Int
    let content: [Review]
}


struct Review: Identifiable, Hashable, Codable {
    let id: Int
    let imageString: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "reviewId"
        case imageString = "imageUrl"
    }
}


struct ReviewDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ReviewDetail
}


struct ReviewDetail: Codable {
    let userProfileImageString: String?
    let userName: String
    let dateString: String
    
    let imageStrings: [String]
    let content: String?
    let rating: Double
    
    let reply: Reply?
}


struct Reply: Identifiable, Codable {
    let id: Int
    let studioName: String
    let dateString: String
    let content: String
}


extension Review {
    static let sample = Review(
        id: 0,
        imageString: "https://imgur.com/YJaYOeA.png"
    )
    
    static let samples: [Review] = (0..<17).map { index in
        Review(
            id: index,
            imageString: "https://imgur.com/YJaYOeA.png"
        )
    }
    
    var imageURL: URL {
        URL(string: imageString ?? "https://imgur.com/YJaYOeA.png") ?? .defaultImageURL
    }
}


extension ReviewDetail {
    static let sample = ReviewDetail(
        userProfileImageString: "https://imgur.com/YJaYOeA.png",
        userName: "김마루",
        dateString: "2024-9-02T10:12:30",
        imageStrings: [
            "https://imgur.com/YJaYOeA.png",
            "https://imgur.com/YJaYOeA.png",
            "https://imgur.com/YJaYOeA.png"
        ],
        content: "인생샷을 건졌습니다, 감사합니다!!",
        rating: 4.9,
        reply: Reply.sample
    )
    
    var userProfileImageURL: URL {
        if let userProfileImageString {
            return URL(string: userProfileImageString) ?? .defaultImageURL
        } else {
            return .defaultImageURL
        }
    }
    
    var imageURLs: [URL] {
        imageStrings.map { imageString in
            URL(string: imageString) ?? .defaultImageURL
        }
    }
}


extension Reply {
    static let sample = Reply(
        id: 0,
        studioName: "마루 스튜디오",
        dateString: "2024-10-02T10:15:30",
        content: "감사합니다, 고객님! 다음에 또 방문해주세요 :)"
    )
}
