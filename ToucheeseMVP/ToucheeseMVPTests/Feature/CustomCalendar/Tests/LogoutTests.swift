//
//  LogoutTests.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/22/25.
//

import Testing
import Foundation

@testable import ToucheeseMVP

struct LogoutTests {
    
    @Test("로그아웃했을 때 예약 내역 초기화되는지")
    func logout_reservation_reset() async  {
        // Given
        let viewModel = makeMyPageViewModel()
        let reservationViewModel = makeReservationListViewModel()
        
        await reservationViewModel.getReservationList()
        
        // When
        await viewModel.logout()
        
        // Then
        #expect(reservationViewModel.reservationList == [])
    }
    
    @Test("로그아웃했을 때 문의 내역 초기화되는지")
    func logout_question_reset() async  {
        // Given
        let viewModel = makeMyPageViewModel()
        let questionViewModel = makeQuestionViewModel()
        
        // When
        await viewModel.logout()
        
        // Then
        #expect(questionViewModel.questions == [])
    }
}

extension LogoutTests {
    func makeMyPageViewModel() -> (any MyPageViewModelProtocol & PrivateMyPageViewModelProtocolLogic) {
        
        let tokenService: TokenService = MockTokenService()
        let memberService: MemberService = MockMemberService()
        
        let viewModel = MyPageViewModel(
            tokenService: tokenService,
            memberService: memberService,
            navigationManager: .init()
        )
        
        return viewModel
    }
    
    func makeReservationListViewModel() -> (any ReservationTabViewModelProtocol & PrivateReservationTabViewModelProtocolLogic) {
        let memberService = MockMemberService()
        
        let viewModel = ReservationListViewModel(memberService: memberService)
        
        return viewModel
    }
    
    func makeQuestionViewModel() -> (any QuestionViewModelProtocol & PrivateQuestionViewModelProtocolLogic) {
        let questionService: QuestionsService = MockQuestionService()
        
        let viewModel = QuestionViewModel(questionService: questionService)
        
        return viewModel
    }
}
