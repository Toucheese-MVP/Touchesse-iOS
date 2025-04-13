//
//  ReservationEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/8/25.
//

struct ReservationEntity: Decodable {
    let content: [Reservation]
    /// pagenation을 위한 변수들
    let last: Bool
    let first: Bool
    let empty: Bool
    let totalPages: Int
    let totalElements: Int
    let size: Int
}

struct Reservation: Decodable, Hashable {
    let reservationId: Int
    let studioId: Int
    let studioName: String
    let studioImage: String
    let productId: Int
    let productName: String
    let createDate: String
    let createTime: String
    let status: String
}
