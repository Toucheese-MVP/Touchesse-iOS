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
}
