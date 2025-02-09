//
//  ReservationDetailViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/4/25.
//

import Foundation

protocol ReservationDetailViewModelProtocol: ObservableObject {
    
}

final class ReservationDetailViewModel: ReservationDetailViewModelProtocol {
    let networkManager = NetworkManager.shared
    let authManager = AuthenticationManager.shared
    
    @Published private(set) var reservation: Reservation
    
    init(reservation: Reservation) {
        self.reservation = reservation
    }
    
    //MARK: - Network
    
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
}
