//
//  Int+MoneyStringFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/28/24.
//

import Foundation

// MARK: Int값을 금액에 맞는 형식의 String 타입으로 사용하기 위한 확장자
extension Int {
    /// Int값을 3000₩원 과 같은 String 형식으로 반환
    var moneyStringFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "원"
    }
}
