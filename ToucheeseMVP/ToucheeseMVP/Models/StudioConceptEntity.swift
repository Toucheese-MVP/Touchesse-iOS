//
//  StudioConcept.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/10/25.
//

import Foundation

struct StudioConceptEntity: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
}

extension StudioConceptEntity {
    var shortedName: String {
        return String(name.dropLast(3))
    }
}
