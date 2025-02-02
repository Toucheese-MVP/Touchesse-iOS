//
//  KakaoLoginRequest.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/22/25.
//

import Foundation

struct KakaoLoginRequest {
    let idToken: String
    let accessToken: String
    let platform: String
    let deviceId: String?
    
    init(idToken: String, accessToken: String, platform: String, deviceId: String? = nil) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.platform = platform
        self.deviceId = deviceId
    }
}
