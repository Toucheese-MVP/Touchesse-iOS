//
//  ReservationService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation

protocol ReservationService {
    /// 즉시 예약
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity
    /// 예약 내역 불러오기
    func getReservations(page: Int) async throws -> ReservationEntity
}

final class DefaultReservationService: BaseService { }

extension DefaultReservationService: ReservationService {
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity {
        let fetchRequest = ReservationAPI.reservationInstant(reservation)
        let result = try await performRequest(fetchRequest, decodingType: ReservationInstantEntity.self)

        return result
    }

    func getReservations(page: Int) async throws -> ReservationEntity {
        let request = ReservationAPI.getReservation(page)
        let result = try await performRequest(request, decodingType: ReservationEntity.self)
        
        return result
    }
}
