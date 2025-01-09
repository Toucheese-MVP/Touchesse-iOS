//
//  DateFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/29/24.
//

import Foundation

// MARK: - TODO: 디자인 적용 끝나고 안쓰는 DateFormat 삭제합시다~
enum DateFormat: String {
    case hourMinute = "HH:mm"
    case monthDayTime = "MM월 dd일 HH:mm"
    case yearMonth = "yyyy년 MM월"
    case yearMonthDay = "yyyy.M.d."
    case requestYearMonthDay = "yyyy-MM-dd"
    case requestTime = "HH:mm:ss"
    case reservationInfoDay = "yyyy년 MM월 dd일"
    case reservationInfoTime = "a hh:mm"
    
    func toDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}
