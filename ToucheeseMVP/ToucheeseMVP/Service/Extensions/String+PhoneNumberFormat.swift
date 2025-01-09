//
//  String+PhoneNumberFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

extension String {
    var phoneNumberString: String {
        let areaCode = self.prefix(3) // "010"
        let middle = self.dropFirst(3).prefix(4) // "1234"
        let last = self.suffix(4) // "5678"
        
        return "\(areaCode)-\(middle)-\(last)"
    }
}
