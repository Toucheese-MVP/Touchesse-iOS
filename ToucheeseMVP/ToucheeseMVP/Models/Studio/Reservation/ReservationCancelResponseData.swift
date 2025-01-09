//
//  ReservationCancelResponseData.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/9/24.
//

import Foundation

struct ReservationCancelResponseData: Codable {
    let statusCode: Int
    let msg: String
    let data: Data?
}
