//
//  StudioCalendarEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 1/16/25.
//

import Foundation

struct StudioCalendarEntity: Decodable {
    let date: String
    let status: Bool
    let tiems: [String]
}
