//
//  Member.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/11/24.
//

import Foundation

// MARK: - 임시 작성
struct Member: Codable {
    let id: Int
    let name, nickname, profileImageURL: String
    let device: String

    enum CodingKeys: String, CodingKey {
        case id, name, nickname
        case profileImageURL = "profileImageUrl"
        case device
    }
}
