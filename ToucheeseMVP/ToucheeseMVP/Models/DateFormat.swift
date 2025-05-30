//
//  DateFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/29/24.
//

import Foundation

enum DateFormat: String {
    case hourMinute = "HH:mm"
    case monthDayTime = "MM월 dd일 HH:mm"
    case yearMonth = "yyyy년 MM월"
    case requestYearMonthDay = "yyyy-MM-dd"
    case requestTime = "HH:mm:ss"
    case reservationInfoDay = "yyyy년 MM월 dd일"
    case reservationInfoTime = "a hh:mm"
    case studioCalendarRequest = "yyyy-MM"
    case YYMMDD = "yy.mm.dd"
    
    func toDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}
