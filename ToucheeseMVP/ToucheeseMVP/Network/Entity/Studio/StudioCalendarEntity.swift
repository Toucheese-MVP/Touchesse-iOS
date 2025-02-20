//
//  StudioCalendarEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 1/16/25.
//

import Foundation

struct StudioCalendarEntity: Decodable, Hashable {
    let date: String
    let status: Bool
    let times: [String]
}

extension StudioCalendarEntity {
    var presentingDate: String {
        // 날짜 문자열 - 기준으로 분리
        let dateParts = self.date.split(separator: "-")
        
        // 숫자로 변환하면 앞의 0이 제거됨
        if let day = dateParts.last, let dayInt = Int(day) {
            return "\(dayInt)"
        }
        
        return self.date
    }
    
    var dateType: Date {
        return date.toDate(dateFormat: .requestYearMonthDay) ?? Date()
    }
}
