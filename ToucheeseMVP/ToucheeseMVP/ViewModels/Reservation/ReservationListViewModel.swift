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
    /// 새로고침일 때 예약 리스트 불러오기
    func refreshAction() async
  
}

final class ReservationListViewModel: ReservationTabViewModelProtocol {
    private let memberService = DefaultMemberService(session: SessionManager.shared.authSession)
    
    @Published private(set) var reservationList: [Reservation] = []
    
    private var nextPage = 0
    private var isLastPage = false
    
    //MARK: - Network
    
    @MainActor
    func getReservationList() async {
        if !isLastPage {
            do {
                print("\(nextPage)")
                print("\(isLastPage)")
                let result = try await memberService.getReservations(page: nextPage)
                reservationList += result.content
                nextPage += 1
                isLastPage = result.last
                
                print("\(reservationList)")
            } catch {
                print("get reservation fail!")
            }
        }
    }
    
    @MainActor
    func refreshAction() async {
        reservationList = []
        nextPage = 0
        isLastPage = false
        await getReservationList()
    }
}
