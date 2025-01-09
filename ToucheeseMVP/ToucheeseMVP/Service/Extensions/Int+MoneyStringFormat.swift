//
//  Int+MoneyStringFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/28/24.
//

import Foundation

extension Int {
    var moneyStringFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "원"
    }
}
