//
//  ReservableTime.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/17/24.
//

import Foundation

struct ReservableTimeData: Codable {
    let statusCode: Int
    let msg: String
    let data: ReservableTime
}

struct ReservableTime: Codable {
    let studioName: String
    let reservableTimeArray: [String]
    let openingTime: String
    let lastReservationTime: String
    
    enum CodingKeys: String, CodingKey {
        case studioName
        case reservableTimeArray = "availableSlots"
        case openingTime
        case lastReservationTime
    }
}

struct ReservableTimeSlot: Hashable {
    var reservableTime: String
    var isAvailable: Bool
}

extension ReservableTime {
    var usableReservableTimeArray: [String] {
        return reservableTimeArray.map { String($0.dropLast(3))}
    }
}

