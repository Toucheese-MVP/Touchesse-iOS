//
//  Date+ToString.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/30/24.
//

import Foundation

extension Date {
    /// Date 타입을 format에 맞게 String 타입으로 리턴하는 함수
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: self)
    }
}
