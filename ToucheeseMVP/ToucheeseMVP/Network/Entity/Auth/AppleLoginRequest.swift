//
//  AppleLoginRequest.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/4/25.
//

import Foundation

struct AppleLoginRequest {
    let idToken: String
    let platform: String
    let username: String?
    let deviceId: String?
    
    init(idToken: String, platform: String, username: String? = "",deviceId: String? = nil) {
        self.idToken = idToken
        self.platform = platform
        self.username = username
        self.deviceId = deviceId
    }
}
