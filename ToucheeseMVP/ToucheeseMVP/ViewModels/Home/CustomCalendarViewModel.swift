//
//  CustomCalendarViewModel.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/19/25.
//

import Foundation

protocol CalendarViewModelProtocol: ObservableObject {
    /// 캘린더 상단에 표시되는 달 문자열
    var topMonthString: String { get }
    /// 캘린더의 현재 달 정보
    var calendarMonth: Date { get }
    /// 날짜 선택이 가능한지 여부
    var isConfirmable: Bool { get }
    
    /// 스튜디오 캘린더 정보
    var studioCalendarEntities: [StudioCalendarEntity] { get }
    /// 스튜디오 예약 가능 시간
    var studioReservableTime: (AM: [String], PM: [String]) { get }
    
    /// 날짜 선택
    func selectDate(date: Date) async
    /// 시간 선택
    func selectTime(date: Date) async
    /// 이전 달 선택
    func selectPreviousMonth()
    /// 다음 달 선택
    func selectNextMonth()
    /// 선택 확정
    func confirmSelect() -> Date?
    /// 선택된 날짜인지 여부
    func isSelectedDate(_ date: Date) -> Bool
    /// 선택된 시간인지 여부
    func isSelectedTime(_ date: Date) -> Bool
}

protocol PrivateCalendarViewModelProtocolLogic {
    /// 캘린더 화면에 표시되는 날짜
    var displayDate: Date { get }
    
    /// 캘린더 화면에 표시되는 시간
    var displayTimeString: String { get }
    
    /// 캘린더 화면에 표시되는 달 문자열
    func updatePresentingMonthString()
    
    /// 스튜디오 캘린더 정보 Fetch
    func fetchStudioCalendar(_ date: Date) async
}

final class CustomCalendarViewModel: CalendarViewModelProtocol, PrivateCalendarViewModelProtocolLogic {
    // MARK: - Datas
    // private let studioService = DefaultStudioService(session: SessionManager.shared.baseSession)
    private let studioService: StudioService
    
    /// 스튜디오 ID
    private let studioID: Int
    
    /// 이전에 선택된 날짜
    private let preSelectedDate: Date?
    
    /// 스튜디오 캘린더 데이터
    @Published private(set) var studioCalendarEntities: [StudioCalendarEntity] = [] {
        didSet {
            print(studioCalendarEntities)
        }
    }
    
    /// 캘린더 상단에 표시되는 달 문자열
    @Published private(set) var topMonthString: String = Date().toString(format: .yearMonth)
    
    /// 캘린더의 현재 달 정보
    @Published private(set) var calendarMonth: Date = Date() {
        // 달 변경 시 화면에 표시되는 PresentingMonth 업데이트
        didSet {
            updatePresentingMonthString()
        }
    }
    
    /// 캘린더 화면에 표시되는 날짜
    @Published private(set) var displayDate = Date()
    
    /// 캘린더 화면에 표시되는 시간
    @Published private(set) var displayTimeString: String = ""
    
    /// 스튜디오 예약 가능 시간
    @Published private(set) var studioReservableTime: (AM: [String], PM: [String]) = (AM: [], PM: [])
    
    /// 스튜디오 예약이 가능한지 여부
    var isConfirmable: Bool {
        if displayTimeString == "" || displayDate.isPast {
            return false
        } else {
            return true
        }
    }
    
    // 현재 날짜의 정보를 가져오는 계산 속성
    var calendar: Calendar { Calendar.current }
    
    
    // MARK: - Init
    init(studioID: Int, preSelectedDate: Date? = nil, studioService: StudioService = DefaultStudioService(session: SessionManager.shared.baseSession)) {
        self.studioID = studioID
        self.preSelectedDate = preSelectedDate
        self.studioService = studioService
        
        Task {
            // 이전에 선택된 날짜가 있는 경우 이전에 선택된 날짜 기준으로 Fetch
            await fetchStudioCalendar(preSelectedDate ?? Date())
            await calReservableTimes()
            
            // 이전에 선택된 날짜가 있는 경우 이전에 선택된 날짜 기준으로 화면에 표시
            if let preSelectedDate {
                await selectDate(date: preSelectedDate)
                await selectTime(date: preSelectedDate)
            }
        }
    }
    
    
    // MARK: - Logics
    @MainActor
    func selectDate(date: Date) async {
        displayDate = date
        await calReservableTimes()
    }
    
    @MainActor
    func selectTime(date: Date) async {
        displayTimeString = date.toString(format: .hourMinute)
    }
    
    func selectPreviousMonth() {
        calendarMonth = calendar.date(byAdding: .month, value: -1, to: calendarMonth) ?? calendarMonth
        
        Task {
            await fetchStudioCalendar(calendarMonth)
            
            await MainActor.run {
                displayTimeString = ""
            }
        }
    }
    
    func selectNextMonth() {
        calendarMonth = calendar.date(byAdding: .month, value: +1, to: calendarMonth) ?? calendarMonth
        
        Task {
            await fetchStudioCalendar(calendarMonth)
            
            await MainActor.run {
                displayTimeString = ""
            }
        }
    }
    
    func confirmSelect() -> Date? {
        guard let dateTypeTime = displayTimeString.toDate(dateFormat: .hourMinute) else { return nil }
        
        let resultDate = calendar.date(
            bySettingHour: calendar.component(.hour, from: dateTypeTime),
            minute: calendar.component(.minute, from: dateTypeTime),
            second: 0,
            of: displayDate
        )
        
        return resultDate ?? nil
    }
    
    func isSelectedDate(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: displayDate)
    }
    
    func isSelectedTime(_ date: Date) -> Bool {
        let timeString = date.toString(format: .hourMinute)
        return displayTimeString == timeString
    }
    
    func calReservableTimes() async {
        guard let reservableTimes = studioCalendarEntities.first(where: { calendar.isDate($0.dateType, inSameDayAs: displayDate)})?.times else { return }
        
        let amTimes = reservableTimes.filter { time in
            let hour = Int(time.prefix(2)) ?? 0
            return hour < 12
        }
        
        let pmTimes = reservableTimes.filter { time in
            let hour = Int(time.prefix(2)) ?? 0
            return hour >= 12
        }
        
//        DispatchQueue.main.async {
//            self.studioReservableTime = (AM: amTimes, PM: pmTimes)
//        }
        
        await MainActor.run {
            studioReservableTime = (AM: amTimes, PM: pmTimes)
        }
    }
    
    
    // MARK: - Private Logics
    func updatePresentingMonthString() {
        topMonthString = calendarMonth.toString(format: .yearMonth)
    }
    
    @MainActor
    func fetchStudioCalendar(_ date: Date) async {
        let dateString = date.toString(format: .studioCalendarRequest)
        
        do {
            studioCalendarEntities = try await studioService.getStudioCalendar(studioId: studioID, yearMonth: dateString)
        } catch {
            print("fetchStudioCalendar ERROR \(error.localizedDescription)")
        }
    }
}
