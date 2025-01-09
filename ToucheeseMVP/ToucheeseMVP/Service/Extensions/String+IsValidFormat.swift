//
//  String+IsEmailFormat.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/14/24.
//

import Foundation

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
