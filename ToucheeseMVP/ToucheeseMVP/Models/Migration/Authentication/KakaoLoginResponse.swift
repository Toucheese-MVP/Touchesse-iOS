//
//  KakaoLoginResponse.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/23/25.
//

import Foundation

struct KakaoLoginResponse: Decodable, ResponseWithHeadersProtocol {
    let memberId: Int
    let email: String
    let nickname: String
    let isFirstLogin: Bool
    let refreshToken: String
    let deviceId: String
    var headers: [String : String]?
}
