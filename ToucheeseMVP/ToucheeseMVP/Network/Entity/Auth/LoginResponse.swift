//
//  LoginResponse.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/4/25.
//

import Foundation

struct SocialLoginResponse: Decodable, ResponseWithHeadersProtocol {
    let memberId: Int
    let email: String
    let nickname: String
    let isFirstLogin: Bool
    let refreshToken: String
    let deviceId: String
    var headers: [String: String]?
}
