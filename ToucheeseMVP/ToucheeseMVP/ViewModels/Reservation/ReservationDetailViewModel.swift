//
//  ReservationDetailViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/4/25.
//

import Foundation

protocol ReservationDetailViewModelProtocol: ObservableObject {
    /// 예약 취소 버튼을 UI에 표시해야하는지에 대한 여부
    func isShowingReservationCancelButton() -> Bool
    /// 예약 취소
    func cancelReservation() async
}

final class ReservationDetailViewModel: ReservationDetailViewModelProtocol {
    let authManager = AuthenticationManager.shared
    let memberService = DefaultMemberService(session: SessionManager.shared.authSession)
    
    @Published private(set) var reservation: Reservation
    
    init(reservation: Reservation) {
        self.reservation = reservation
    }
    
    //MARK: - Network

    /// 예약 취소 버튼을 UI에 표시해야하는지에 대한 여부
    func isShowingReservationCancelButton() -> Bool {
        switch reservation.status {
        case ReservationStatus.complete.title, ReservationStatus.cancel.title:
            false
        case ReservationStatus.waiting.title, ReservationStatus.confirm.title:
            true
        default:
            false
        }
    }
    
    /// 예약 취소
    func cancelReservation() async {
        let request = CancelReservationRequest(reservationID: reservation.reservationId, createDate: reservation.createDate, createTime: reservation.createTime)
        
        do {
            try await memberService.cancelReservation(request)
            
            // 예약 내역을 초기화하도록 NotificationManager에 전달
            NotificationManager.shared.postRefreshReservation()
        } catch {
            print("Cancel Reservation Error: \(error.localizedDescription)")
        }
    }
}
