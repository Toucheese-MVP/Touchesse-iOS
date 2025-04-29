//
//  ReservationListViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/8/25.
//

import Foundation
import Combine

protocol ReservationTabViewModelProtocol: ObservableObject {
    var reservationList: [Reservation] { get }
    
    /// 예약 리스트 불러오기
    func getReservationList() async
    /// 새로고침일 때 예약 리스트 불러오기
    func refreshAction() async
  
}

protocol PrivateReservationTabViewModelProtocolLogic {
    /// 예약 내역 갱신 이벤트를 구독
    func subscribeRefreshReservation()
    func subscribeResetReservation()
}

final class ReservationListViewModel: ReservationTabViewModelProtocol, PrivateReservationTabViewModelProtocolLogic {
    private let memberService: MemberService
    
    @Published private(set) var reservationList: [Reservation] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var nextPage = 0
    private var isLastPage = false
    
    init(memberService: MemberService) {
        self.memberService = memberService
        subscribeRefreshReservation()
        subscribeResetReservation()
    }
    
    
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
        resetAction()
        await getReservationList()
    }
    
    /// 예약 내역 갱신 이벤트를 구독
    func subscribeRefreshReservation() {
        NotificationManager.shared.refreshReservationPublisher
            .sink { [weak self] _ in
                Task {
                    await self?.refreshAction()
                    print("예약 내역이 갱신")
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func resetAction() {
        reservationList = []
        nextPage = 0
        isLastPage = false
    }
    
    /// 예약 내역 초기화 이벤트를 구독
    func subscribeResetReservation() {
        NotificationManager.shared.resetReservationPublisher
            .sink { [weak self] _ in
                Task {
                    await self?.resetAction()
                    print("예약 내역 초기화")
                    print("\(KeychainManager.shared.read(forAccount: .accessToken))")
                }
            }
            .store(in: &cancellables)
    }
}
