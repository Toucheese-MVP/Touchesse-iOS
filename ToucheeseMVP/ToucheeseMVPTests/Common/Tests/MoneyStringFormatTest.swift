//
//  Test.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Testing
@testable import ToucheeseMVP

struct MoneyFormatTests {
    enum Moneys: CaseIterable {
        case thousand
        case zero
        case negative
        case million
        
        var input: Int {
            switch self {
            case .thousand:
                3000
            case .zero:
                0
            case .negative:
                -200
            case .million:
                1000000
            }
        }
        
        var expected: String {
            switch self {
            case .thousand:
                "3,000원"
            case .zero:
                "0원"
            case .negative:
                "-200원"
            case .million:
                "1,000,000원"
            }
        }
    }
    
    @Test(arguments: Moneys.allCases)
    func test_MoneyStringFormat_MultipleCases(moneyCase: Moneys) async throws {
        #expect(moneyCase.input.moneyStringFormat == moneyCase.expected, "test_MoneyStringFormat_MultipleCases Failed for input: \(moneyCase.input)")
    }
}
