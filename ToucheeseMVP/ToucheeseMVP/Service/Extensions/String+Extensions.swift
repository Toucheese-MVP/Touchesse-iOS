//
//  String+Extensions.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/3/25.
//

import Foundation

extension String {
    /// access 토큰 응답값 앞의 Bearer를 삭제한 변수
    var removeBearer: String {
        self.hasPrefix("Bearer ") ? String(self.dropFirst(7)) : self
    }
}
