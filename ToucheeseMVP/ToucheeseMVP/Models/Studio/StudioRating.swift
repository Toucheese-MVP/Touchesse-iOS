//
//  StudioRating.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/14/25.
//

import Foundation

enum StudioRating: String, OptionType, CaseIterable {
    case all = "전체"
    case moreThanOne = "1.0점 이상"
    case moreThanTwo = "2.0점 이상"
    case moreThanThree = "3.0점 이상"
    case moreThanFour = "4.0점 이상"
    case moreThanFive = "5.0점 이상"
    
    var id: Int {
        switch self {
        case .all:
            1
        case .moreThanOne:
            2
        case .moreThanTwo:
            3
        case .moreThanThree:
            4
        case .moreThanFour:
            5
        case .moreThanFive:
            6
        }
    }
    
    var title: String { self.rawValue }
    
    var querryParameter: Double? {
        switch self {
        case .all:
            nil
        case .moreThanOne:
            1.0
        case .moreThanTwo:
            2.0
        case .moreThanThree:
            3.0
        case .moreThanFour:
            4.0
        case .moreThanFive:
            5.0
        }
    }
}
