//
//  MockStudioService.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 4/17/25.
//

import Foundation
@testable import ToucheeseMVP

final class MockStudioService: StudioService {
    func getStudioCalendar(studioId: Int, yearMonth: String?) async throws -> [ToucheeseMVP.StudioCalendarEntity] {
        return [
            StudioCalendarEntity(date: "2025-01-15", status: true, times: [
                "11:00",
                "12:00",
                "14:00",
                "15:00",
                "16:00",
                "17:00",
                "19:00",
                "20:00",
                "21:00",
                "22:00",
            ]),
            StudioCalendarEntity(date: "2025-01-16", status: false, times: [
                "11:00",
                "12:00",
                "14:00",
                "15:00",
                "16:00",
                "17:00",
                "19:00",
                "20:00",
                "21:00",
                "22:00",
            ]),
        ]
    }
    
    func getStudioDetail(studioID: Int) async throws -> ToucheeseMVP.StudioDetailEntity {
        return StudioDetailEntity.sample
    }
    
    func getStudioReviewList(studioId: Int) async throws -> [ToucheeseMVP.StudioReviewEntity] {
        return []
    }
    
    func getReviewDetail(studioId: Int, reviewId: Int) async throws -> ToucheeseMVP.ReviewDetailEntity {
        return ReviewDetailEntity(id: 1, content: "", rating: 0.0, reviewImages: [])
    }
    
    func postReview(_ request: ToucheeseMVP.ReviewRequest) async throws {
        return
    }
}
