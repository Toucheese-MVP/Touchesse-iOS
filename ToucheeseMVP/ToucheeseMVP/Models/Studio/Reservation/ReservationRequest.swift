//
//  ReservationRequest.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

/// 예약 요청 타입
struct ReservationRequest {
    let memberId: Int
    let studioId: Int
    let reservationDate: Date
    let productId: Int
    let productOptions: [ProductOption]
    let totalPrice: Int
    let phoneNumber: String
    let email: String
    let addPeopleCnt: Int

    var reservationDateString: String {
        reservationDate.toString(format: .requestYearMonthDay)
    }
    
    var reservationTimeString: String {
        reservationDate.toString(format: .requestTime)
    }
    
    var productOptionString: String {
        productOptions.map { "\($0.name):\($0.price)"}.joined(separator: "@")
    }
    
    var phoneNumberString: String {
        phoneNumber.phoneNumberString
    }
    
    init(
        memberId: Int,
        studioId: Int,
        reservationDate: Date,
        productId: Int,
        productOptions: [ProductOption],
        totalPrice: Int,
        phoneNumber: String,
        email: String,
        addPeopleCnt: Int
    ) {
        self.memberId = memberId
        self.studioId = studioId
        self.reservationDate = reservationDate
        self.productId = productId
        self.productOptions = productOptions
        self.totalPrice = totalPrice
        self.phoneNumber = phoneNumber
        self.email = email
        self.addPeopleCnt = addPeopleCnt
    }
}

//struct ReservationTime {
//    var hour: Int
//    var minute: Int
//    let second = 0
//    var nano = 0
//}
