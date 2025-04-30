//
//  ReservationService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation

protocol MemberService {
    /// 즉시 예약
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity
    /// 예약 내역 불러오기
    func getReservations(page: Int) async throws -> ReservationEntity
    /// 사용자 회원탈퇴
    func cleanupUser() async throws
    /// 예약 취소
    func cancelReservation(_ cancelReservationRequest: CancelReservationRequest) async throws
}

final class DefaultMemberService: BaseService { }

extension DefaultMemberService: MemberService {
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity {
        let fetchRequest = MemberAPI.reservationInstant(reservation)
        let result = try await performRequest(fetchRequest, decodingType: ReservationInstantEntity.self)

        return result
    }

    func getReservations(page: Int) async throws -> ReservationEntity {
        let request = MemberAPI.getReservation(page)
        let result = try await performRequest(request, decodingType: ReservationEntity.self)
        
        return result
    }
    
    func cleanupUser() async throws {
        let request = MemberAPI.cleanup
        _ = try await performRequest(request, decodingType: String.self)
    }
    
    func cancelReservation(_ cancelReservationRequest: CancelReservationRequest) async throws {
        let request = MemberAPI.cancelReservation(cancelReservationRequest)
        _ = try await performRequest(request, decodingType: String.self)
    }
}

final class MockMemberService: MemberService {
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity {
        return .init(status: .random())
    }
    
    func getReservations(page: Int) async throws -> ReservationEntity {
        return .init(content: [.init(reservationId: 0, studioId: 0, studioName: "mockStudioName", studioImage: "", productId: 0, productName: "mockProductName", createDate: "", createTime: "", status: "")], last: true, first: true, empty: false, totalPages: 1, totalElements: 3, size: 10)
    }
    
    func cleanupUser() async throws {
        
    }
    
    func cancelReservation(_ cancelReservationRequest: CancelReservationRequest) async throws {
        
    }
}
