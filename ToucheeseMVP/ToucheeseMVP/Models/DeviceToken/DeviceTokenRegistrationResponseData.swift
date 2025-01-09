//
//  DeviceTokenRegistrationResponseData.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/11/24.
//

import Foundation

struct DeviceTokenRegistrationResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: DeviceTokenRegistrationResponse?
}


struct DeviceTokenRegistrationResponse: Codable {
    let id: Int
    let member: Member
    let deviceToken: String
}
