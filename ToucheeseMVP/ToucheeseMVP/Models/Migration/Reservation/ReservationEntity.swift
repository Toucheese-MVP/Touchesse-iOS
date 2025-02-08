//
//  ReservationEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/8/25.
//

//TODO: 페이지네이션 적용
struct ReservationEntity: Decodable {
    let content: [TempReservation]
    /// pagenation을 위한 변수들
    let last: Bool
    let first: Bool
    let empty: Bool
    let totalPages: Int
    let totalElements: Int
    let size: Int
}

struct TempReservation: Decodable {
    let reservationId: Int
    let studioId: Int
    let studioName: String
    let studioImage: String
    let productName: String
    let createDate: String
    let createTime: String
    let status: String
}
