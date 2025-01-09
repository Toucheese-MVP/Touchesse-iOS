//
//  LoginResponse.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/20/24.
//

import Foundation

struct LoginResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: LoginResponse
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let memberId: Int
    let memberName: String
}
