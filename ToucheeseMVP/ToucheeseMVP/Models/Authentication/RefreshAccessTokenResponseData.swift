//
//  RefreshAccessTokenResponseData.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation

struct RefreshAccessTokenResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: RefreshAccessTokenResponse
}


struct RefreshAccessTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
