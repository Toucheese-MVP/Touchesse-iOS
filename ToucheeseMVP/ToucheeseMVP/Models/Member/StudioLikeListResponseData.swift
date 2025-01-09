//
//  StudioLikeListResponseData.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/26/24.
//

import Foundation

struct StudioLikeListResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: [Studio]
}
