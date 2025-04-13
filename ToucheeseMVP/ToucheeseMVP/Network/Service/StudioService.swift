//
//  StudioService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation

protocol StudioService {
    /// 스튜디오 예약에 필요한 캘린더 데이터 요청
    func getStudioCalendar(studioId: Int, yearMonth: String?) async throws -> [StudioCalendarEntity]
    /// 스튜디오 상세 데이터 요청
    func getStudioDetail(studioID: Int) async throws -> StudioDetailEntity
    /// 스튜디오 리뷰 목록 조회
    func getStudioReviewList(studioId: Int) async throws -> [StudioReviewEntity]
    /// 특정 리뷰 상세 조회
    func getReviewDetail(studioId: Int, reviewId: Int) async throws -> ReviewDetailEntity
    /// 리뷰 작성
    func postReview(_ request: ReviewRequest) async throws
}

final class DefaultStudioService: BaseService { }

extension DefaultStudioService: StudioService {
    @MainActor
    func getStudioCalendar(studioId: Int, yearMonth: String?) async throws -> [StudioCalendarEntity] {
        let fetchRequest = StudioAPI.studioCalendar(studioID: studioId, yearMonth: yearMonth)
    
        let entity = try await performRequest(fetchRequest, decodingType: [StudioCalendarEntity].self)
    
        return entity
    }
    
    func getStudioDetail(studioID: Int) async throws -> StudioDetailEntity {
        let fetchRequest = StudioAPI.studioDetail(studioID: studioID)
    
        let studioDetailEntity = try await performRequest(
            fetchRequest,
            decodingType: StudioDetailEntity.self
        )
    
        return studioDetailEntity
    }
    
    func getStudioReviewList(studioId: Int) async throws -> [StudioReviewEntity] {
        let request = StudioAPI.studioReviewList(studioID: studioId)
        let result = try await performRequest(request, decodingType: [StudioReviewEntity].self)
        
        return result
    }
    
    func getReviewDetail(studioId: Int, reviewId: Int) async throws -> ReviewDetailEntity {
        let request = StudioAPI.reviewDetail(studioID: studioId, reviewID: reviewId)
        let result = try await performRequest(request, decodingType: ReviewDetailEntity.self)
        
        return result
    }
    
    func postReview(_ request: ReviewRequest) async throws {
        let request = StudioAPI.postReview(request)
        
        _ = try await performRequest(request, decodingType: String.self)
    }
}
