//
//  ReservationListViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/8/25.
//

import Foundation

protocol ReservationTabViewModelProtocol: ObservableObject {
    var reservationList: [Reservation] { get }
    
    /// 예약 리스트 불러오기
    func getReservationList() async
  
}

final class ReservationListViewModel: ReservationTabViewModelProtocol {
    private let network = NetworkManager.shared
    
    @Published private(set) var reservationList: [Reservation] = []
    
    //MARK: - Network
    
    @MainActor
    func getReservationList() async {
        do {
            reservationList = try await network.getReservations().content
            print("\(reservationList)")
        } catch {
            print("get reservation fail!")
        }
    }
}
