//
//  Date+CalendarFunctions.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/30/24.
//

import Foundation

// MARK: 캘린더 날짜 관련 확장자
extension Date {
    /// 해당 Date에 속한 Month의 첫번째 날을 계산한 변수
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    /// 해당 Date에 속한 Month의 첫번째 요일을 계산한 변수
    var firstWeekday: Int {
        return Calendar.current.component(.weekday, from: self.startOfMonth)
    }
    
    /// 해당 Month에 속한 모든 날짜 배열을 계산한 변수
    var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self.startOfMonth)!
        
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: self.startOfMonth)
        }
    }
    
    /// 해당 Date가 오늘인지 확인하는 변수
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// 해당 Date가 과거 날짜인지 확인하는 변수 (오늘 포함)
    var isPast: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: self)
        return targetDate < today
    }
    
    /// 해당 Date가 휴일에 속하는지 확인하는 변수
    func isHoliday(holidays: [Int]) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: self)
        return holidays.contains(weekday)
    }
    
    /// 해당 Date의 날짜를(1일, 23일 등) 계산하는 변수
    var dayNumber: Int {
        Calendar.current.component(.day, from: self)
    }
    
    static let weekString: [String] = ["", "일", "월", "화", "수", "목", "금", "토"]
    
    /// 해당 Date의 요일을 반환하는 변수
    var dayWeek: String {
        Date.weekString[Calendar.current.component(.weekday, from: self)]
    }
    
    /// 오늘 기준으로 몇일 전인지 계산해서 문자열로 리턴하는 변수
    var pastDayString: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let givenDate = calendar.startOfDay(for: self)
        
        guard let daysDifference = calendar.dateComponents([.day], from: givenDate, to: today).day else {
            return "알 수 없음"
        }
        
        switch daysDifference {
        case 0:
            return "오늘"
        case 1:
            return "어제"
        default:
            return "\(daysDifference)일 전"
        }
    }
}

// MARK: Date 타입을 format에 맞게 String 타입으로 리턴하기 위한 확장자
extension Date {
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: self)
    }
}
