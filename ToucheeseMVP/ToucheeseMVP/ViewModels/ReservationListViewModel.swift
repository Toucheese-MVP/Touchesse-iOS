//
//  ReservationListViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

final class ReservationListViewModel: ObservableObject {
    
    @Published private(set) var reservations: [Reservation] = []
    @Published private(set) var pastReservations: [Reservation] = []
    
    private let authManager = AuthenticationManager.shared
    private let networkManager = NetworkManager.shared
    
    @MainActor
    func fetchReservations() async {
        guard authManager.authStatus == .authenticated else { return }
        
        // MARK: 예약하기 로직을 적용해야 함
//        do {
//            reservations = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [unowned self] token in
//                if let memberId = authManager.memberId {
//                    return try await networkManager.getReservationListDatas(
//                        accessToken: token,
//                        memberID: memberId
//                    )
//                } else {
//                    print("Reservation List Fetch Error: Member ID Not Found")
//                    return []
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Reservation List Fetch Error: Refresh Token Expired")
//            authManager.logout()
//        } catch {
//            print("Reservation List Fetch Error: \(error.localizedDescription)")
//        }
    }
    
    @MainActor
    func fetchPastReservations() async {
        guard authManager.authStatus == .authenticated else { return }
        
        // MARK: 이전 예약 내역을 불러오는 로직을 적용해야 함
//        do {
//            pastReservations = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [unowned self] token in
//                if let memberId = authManager.memberId {
//                    return try await networkManager.getReservationListDatas(
//                        accessToken: token,
//                        memberID: memberId,
//                        isPast: true
//                    )
//                } else {
//                    authManager.logout()
//                    return []
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Past Reservation List Fetch Error: Refresh Token Expired")
//            authManager.logout()
//        } catch {
//            print("Past Reservation List Fetch Error: \(error.localizedDescription)")
//        }
    }
    
}
