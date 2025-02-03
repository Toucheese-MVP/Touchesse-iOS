//
//  ReissueTokenResponse.swift
//  ToucheeseMVP
//
//  Created by 강건 on 1/31/25.
//

import Foundation

struct ReissueTokenResponse: Decodable {
    let memberId: Int
    let email: String
    let name: String
    let refreshToken: String
    let deviceId: String
}
