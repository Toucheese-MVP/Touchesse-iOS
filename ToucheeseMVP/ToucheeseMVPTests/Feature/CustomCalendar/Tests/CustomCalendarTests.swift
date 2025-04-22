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
    enum DateArray: CaseIterable {
        case nov25
        case jan15
        case may5
        
        var date: Date {
            switch self {
            case .nov25:
                return CustomCalendarStub.getDate(year: 2025, month: 11, day: 25)
            case .jan15:
                return CustomCalendarStub.getDate(year: 2025, month: 1, day: 15)
            case .may5:
                return CustomCalendarStub.getDate(year: 2025, month: 3, day: 5)
            }
        }
    }
    
    
    @Test("selectDate() 함수로 DisPlayDate가 선택된 날짜로 변경되는지", arguments: DateArray.allCases)
    func test_selectDate(dateCase: DateArray) async {
        // Given
        let viewModel = makeViewModel()
        
        // When
        await viewModel.selectDate(date: dateCase.date)
        
        // Then
        #expect(viewModel.displayDate == dateCase.date)
    }
    
    @Test("calReservableTimes() 함수로 응답값을 통해 제대로 된 예약 날짜 시간이 계산되는지")
    func test_calReservableTimes() async {
        // Given
        let viewModel = makeViewModel()
        
        // When
        // fetch를 한번 해줘야 조건을 통과합니다.
        // 함수의 동작들이 독립되어 있지 않아 Test 친화적이지 않습니다. 리팩토링이 고려됩니다.
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
    
    @Test("selectTime() 함수로 displayTimeString이 계산되는지")
    func test_selectTime() async {
        // Given
        let viewModel = makeViewModel()
        
        // When
        await viewModel.selectTime(date: CustomCalendarStub.threeAM)
        
        // Then
        #expect(viewModel.displayTimeString == "03:00")        
    }
    
    @Test("selectPreviousMonth() 함수로 calendarMonth가 이전 달의 값으로 바뀌는지")
    func test_selectPreviousMonth() {
        // Given
        let viewModel = makeViewModel()
        let tartgetMonth = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.calendarMonth)
        
        // When
        viewModel.selectPreviousMonth()
        
        // Then
        #expect(viewModel.calendarMonth == tartgetMonth)
    }
    
    @Test("selectNextMonth() 함수로 calendarMonth가 이전 달의 값으로 바뀌는지")
    func test_selectNextMonth() {
        // Given
        let viewModel = makeViewModel()
        let tartgetMonth = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.calendarMonth)
        
        // When
        viewModel.selectNextMonth()
        
        // Then
        #expect(viewModel.calendarMonth == tartgetMonth)
    }
    
    @Test("confirmSelect() 선택했을 때 리턴하는 값이 사용자가 선택한 날짜와 일치하는지", arguments: DateArray.allCases)
    func test_confirmSelect(dateCase: DateArray) async {
        // Given
        let viewModel = makeViewModel()
        let targetDate = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: dateCase.date)
        
        // When
        await viewModel.selectDate(date: dateCase.date)
        await viewModel.selectTime(date: CustomCalendarStub.threeAM)

        // Then
        #expect(viewModel.confirmSelect() == targetDate)
    }
    
    // (1) 선택한 날짜와 일치했을 때 True를 리턴
    // (2) 선택한 날짜와 일치하지 않을 때 False를 리턴
    @Test("isSelectedDate() 함수가 정상적으로 동작하는지", arguments: DateArray.allCases)
    func test_isSelected(dateCase: DateArray) async {
        // Given
        let viewModel = makeViewModel()
        
        // (1)
        // When
        await viewModel.selectDate(date: dateCase.date)
        
        // Then
        #expect(viewModel.isSelectedDate(dateCase.date))
        
        // (2)
        // When
        await viewModel.selectDate(date: Date())
        
        // Then
        #expect(!viewModel.isSelectedDate(dateCase.date))
    }
    
    
    /// Test에 사용할 뷰모델을 만드는 함수
    func makeViewModel() -> (any CalendarViewModelProtocol & PrivateCalendarViewModelProtocolLogic) {
        let studioID: Int = 1
        let studioService: StudioService = MockStudioService()
        
        let viewModel = CustomCalendarViewModel(
            studioID: studioID,
            preSelectedDate: nil,
            studioService: studioService
        )
        
        return viewModel
    }
}
