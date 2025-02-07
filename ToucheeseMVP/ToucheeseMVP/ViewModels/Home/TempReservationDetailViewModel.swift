//
//  TempReservationDetailViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/4/25.
//

import Foundation

final class TempReservationDetailViewModel: ObservableObject {
    
    let networkManager = NetworkManager.shared
    let authManager = AuthenticationManager.shared
    
    @Published private(set) var reservation: Reservation
    @Published private(set) var reservationDetail: ReservationDetail = ReservationDetail.sample
    @Published private(set) var reservedStudio: TempStudio = TempStudio.sample
    
    init(reservation: Reservation) {
        self.reservation = reservation
        
        Task {
//            await fetchReservationDetail(reservationID: reservation.id)
//            await fetchReservedStudio()
        }
    }
    
    func isShowingReservationCancelButton() -> Bool {
        switch reservation.reservationStatus {
        case ReservationStatus.complete.rawValue, ReservationStatus.cancel.rawValue:
            false
        case ReservationStatus.waiting.rawValue, ReservationStatus.confirm.rawValue:
            true
        default:
            false
        }
    }
    
    @MainActor
    func fetchReservationDetail(reservationID: Int) async {
        // TODO: 예약 상세를 불러오는 로직을 적용해야 함
//        do {
//            reservationDetail = try await networkManager.getReservationDetailData(
//                reservationID: reservationID
//            )
//        } catch {
//            print("ReservationDetail Fetch Error: \(error.localizedDescription)")
//        }
    }
    
    @MainActor
    func cancelReservation(reservationID: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Cancel Reservation Error: Not Authenticated")
            return
        }
        
        // MARK: 예약 취소 로직 적용해야 함
//
//        do {
//            try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [self] token in
//                if let memberId = authManager.memberId {
//                    try await networkManager.deleteReservationData(
//                        reservationID: reservationID,
//                        memberID: memberId,
//                        accessToken: token
//                    )
//                } else {
//                    print("Cancel Reservation Error: Member ID Not Found")
//                    authManager.failedAuthentication()
////                    authManager.logout()
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Cancel Reservation Error: Refresh Token Expired")
//            authManager.failedAuthentication()
////            authManager.logout()
//        } catch {
//            print("Cancel Reservation Error: \(error.localizedDescription)")
//        }
    }
    
    @MainActor
    private func fetchReservedStudio() async {
//        do {
//            reservedStudio = try await networkManager.getStudioData(
//                studioID: reservationDetail.studioId
//            )
//        } catch {
//            print("Reserved Studio Fetch Error: \(error.localizedDescription)")
//        }
    }
}
