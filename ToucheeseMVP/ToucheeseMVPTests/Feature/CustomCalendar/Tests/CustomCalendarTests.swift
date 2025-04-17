//
//  ToucheeseMVPTests.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Testing
import Foundation
@testable import ToucheeseMVP

struct CustomCalendarTests {
    @Test("DisPlayDate가 선택된 날짜로 변경되는지")
    func test_selectDate() async throws {
        // Given
        let viewModel = makeViewModel()
        
        // When
        await viewModel.selectDate(date: CustomCalendarStub.jan15)
        
        // Then
        #expect(viewModel.displayDate == CustomCalendarStub.jan15)
    }
    
    @Test("응답값을 통해 제대로 된 예약 날짜 시간이 계산되는지")
    func test_calReservableTimes() async throws {
        // Given
        let viewModel = makeViewModel()
        
        // When
        // fetch를 한번 해줘야 조건을 통과합니다.
        // 함수가 Test 친화적이지 않다는 뜻으로 리팩토링 고려가 가능하겠습니다.
        await viewModel.fetchStudioCalendar(CustomCalendarStub.jan15)
        await viewModel.selectDate(date: CustomCalendarStub.jan15)
        
        // Then
        #expect(
            viewModel.studioReservableTime == (
                (
                    AM: [
                        "11:00",
                    ],
                    PM: [
                        "12:00",
                        "14:00",
                        "15:00",
                        "16:00",
                        "17:00",
                        "19:00",
                        "20:00",
                        "21:00",
                        "22:00",
                    ]
                )
                
            )
        )
    }
    
    /// Test에 사용할 뷰모델을 만드는 함수
    func makeViewModel() -> (any CalendarViewModelProtocol & PrivateCalendarViewModelProtocolLogic) {
        let studioID: Int = 1
        let studioService: StudioService = MockStudioService()
        
        let viewModel: (any CalendarViewModelProtocol & PrivateCalendarViewModelProtocolLogic) =
        CustomCalendarViewModel(
            studioID: studioID,
            preSelectedDate: nil,
            studioService: studioService
        )
        
        return viewModel
    }
}
