//
//  CalendarStub.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Foundation

enum CustomCalendarStub {
    static let jan15: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: "20250115")!
        return date
    }()
}
