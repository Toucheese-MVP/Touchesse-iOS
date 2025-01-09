//
//  Date+CalendarFunctions.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/30/24.
//

import Foundation

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
}
