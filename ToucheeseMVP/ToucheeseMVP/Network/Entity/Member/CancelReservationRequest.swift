//
//  CancelReservationRequest.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/25/25.
//

import Foundation

struct CancelReservationRequest {
    let reservationID: Int
    let createDate: String
    let createTime: String
    let status = "예약취소"
}
