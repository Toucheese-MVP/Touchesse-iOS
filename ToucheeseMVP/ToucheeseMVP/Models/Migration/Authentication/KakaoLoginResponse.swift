//
//  KakaoLoginResponse.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/23/25.
//

import Foundation

struct KakaoLoginResponse: Decodable {
    let memberId: Int
    let nickname: String
    let isFirstLogin: Bool
    let refreshToken: String
    let deviceId: String
}
