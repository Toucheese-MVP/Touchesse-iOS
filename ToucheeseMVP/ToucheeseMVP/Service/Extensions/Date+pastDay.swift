//
//  Date+CalPastDay.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/2/24.
//

import Foundation

extension Date {
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
