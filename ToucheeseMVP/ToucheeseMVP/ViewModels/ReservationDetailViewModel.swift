//
//  ReservationDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

final class ReservationDetailViewModel: ObservableObject {
    
    // MARK: - Data
    @Published private(set) var reservation: Reservation
    @Published private(set) var reservationDetail: ReservationDetail = ReservationDetail.sample
    @Published private(set) var reservedStudio: Studio = Studio.sample
    
    let networkManager = NetworkManager.shared
    let authManager = AuthenticationManager.shared
    
    init(reservation: Reservation) {
        self.reservation = reservation
        
        Task {
            await fetchReservationDetail(reservationID: reservation.id)
            await fetchReservedStudio()
        }
    }
    
    // MARK: - Logic
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
        do {
            reservationDetail = try await networkManager.getReservationDetailData(
                reservationID: reservationID
            )
        } catch {
            print("ReservationDetail Fetch Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func cancelReservation(reservationID: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Cancel Reservation Error: Not Authenticated")
            return
        }
        
        do {
            try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                if let memberId = authManager.memberId {
                    try await networkManager.deleteReservationData(
                        reservationID: reservationID,
                        memberID: memberId,
                        accessToken: token
                    )
                } else {
                    print("Cancel Reservation Error: Member ID Not Found")
                    authManager.logout()
                }
            }
        } catch NetworkError.unauthorized {
            print("Cancel Reservation Error: Refresh Token Expired")
            authManager.logout()
        } catch {
            print("Cancel Reservation Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func fetchReservedStudio() async {
        do {
            reservedStudio = try await networkManager.getStudioData(
                studioID: reservationDetail.studioId
            )
        } catch {
            print("Reserved Studio Fetch Error: \(error.localizedDescription)")
        }
    }
    
}
