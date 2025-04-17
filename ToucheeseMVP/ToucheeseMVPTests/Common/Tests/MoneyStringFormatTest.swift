//
//  Test.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Testing
@testable import ToucheeseMVP

struct MoneyFormatTests {
    @Test func test_MoneyStringFormat_MultipleCases() async throws {
        let testCases: [(input: Int, expected: String)] = [
            (3000, "3,000원"),
            (0, "0원"),
            (-200, "-200원"),
            (1000000, "1,000,000원"),
        ]
        
        for (input, expected) in testCases {
            #expect(input.moneyStringFormat == expected, "test_MoneyStringFormat_MultipleCases Failed for input: \(input)")
        }
    }
}
