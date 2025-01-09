//
//  StudioPrice.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/17/24.
//

import Foundation

enum StudioPrice: String, OptionType, CaseIterable {
    case all = "전체"
    case lessThan100_000won = "10만원 미만"
    case lessThan200_000won = "20만원 미만"
    case moreThan200_000won = "20만원 이상"
    
    var id: Int {
        switch self {
        case .all:
            1
        case .lessThan100_000won:
            2
        case .lessThan200_000won:
            3
        case .moreThan200_000won:
            4
        }
    }
    var title: String { self.rawValue }
}
