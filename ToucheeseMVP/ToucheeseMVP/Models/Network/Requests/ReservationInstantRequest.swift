//
//  ReservationInstantRequestEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/1/25.
//

import Foundation

struct ReservationInstantRequest: Encodable {
    var productId: Int
    var studioId: Int
    var totalPrice: Int
    var createDate: String
    var createTime: String
    var personnel: Int
    var addOptions: [Int]
}
