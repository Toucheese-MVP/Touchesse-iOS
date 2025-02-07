//
//  String+Extensions.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/3/25.
//

import Foundation

// MARK: access 토큰 응답값 앞의 Bearer를 삭제하기 위한 확장자
extension String {
    /// access 토큰 응답값 앞의 Bearer를 삭제한 변수
    var removeBearer: String {
        self.hasPrefix("Bearer ") ? String(self.dropFirst(7)) : self
    }
}

// MARK: 사용자 입력 정보가 형식에 맞는지 확인하기 위한 확장자
extension String {
    var isEmailFormat: Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneLength: Bool {
        return self.count == 11
    }
}

// MARK: 번호를 전화번호 형식으로 바꿔주는 확장자
extension String {
    var phoneNumberString: String {
        let areaCode = self.prefix(3) // "010"
        let middle = self.dropFirst(3).prefix(4) // "1234"
        let last = self.suffix(4) // "5678"
        
        return "\(areaCode)-\(middle)-\(last)"
    }
}

// MARK: Date타입과 연관된 확장자들
extension String {
    func toDate(dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.date(from: self)
    }
    
    /// ISO8601(2023-12-02T10:15:30) 형식의 String을 Date 값으로 계산하는 변수
    var iso8601ToDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current // 로컬 시간대로 간주
        return formatter.date(from: self)
    }
    
    var toReservationDateType: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy년 M월 d일"
            let outputDateString = dateFormatter.string(from: date)
            
            return outputDateString
        } else {
            return ""
        }
    }
}
