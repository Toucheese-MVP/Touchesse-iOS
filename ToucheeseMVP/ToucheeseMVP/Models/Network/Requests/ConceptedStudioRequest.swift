//
//  ConceptedStudioRequest.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/13/25.
//

import Foundation

struct ConceptedStudioRequest {
    let studioConceptId: Int
    let page: Int
    let price: Int?
    let rating: Double?
    let location: [String]?
    
    init(
        studioConceptId: Int,
        page: Int = 1,
        price: Int? = nil,
        rating: Double? = nil,
        location: [String]? = []
    ) {
        self.studioConceptId = studioConceptId
        self.page = page
        self.price = price
        self.rating = rating
        self.location = location
    }
}
