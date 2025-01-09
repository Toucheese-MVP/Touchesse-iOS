//
//  AppOpenResponseData.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation

struct AppOpenResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: AppOpenResponse
}


struct AppOpenResponse: Codable {
    let accessToken: String
    let memberName: String
    let memberId: Int
}
