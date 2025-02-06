//
//  ReservationInstantRequestEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/1/25.
//

import Foundation

struct ReservationInstantRequest: Encodable {
    let productId: Int
    let studioId: Int
    let memberId: Int
    let phone: String
    let totalPrice: Int
    let createDate: String
    let createTime: String
    let personnel: Int
    let addOptions: [Int]
}
