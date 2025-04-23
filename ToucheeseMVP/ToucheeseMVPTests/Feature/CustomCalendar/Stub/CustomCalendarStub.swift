//
//  CalendarStub.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Foundation

enum CustomCalendarStub {
    static let jan15: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: "20250115")!
        return date
    }()
    
    static let threeAM: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 3
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }()
    
    static let fourAM: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 4
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }()
    
    static func getDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.date(from: components)!
    }
}
