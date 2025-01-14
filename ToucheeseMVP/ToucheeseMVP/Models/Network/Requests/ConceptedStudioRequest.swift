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
    
    init(studioConceptId: Int, page: Int = 1) {
        self.studioConceptId = studioConceptId
        self.page = page
    }
}
