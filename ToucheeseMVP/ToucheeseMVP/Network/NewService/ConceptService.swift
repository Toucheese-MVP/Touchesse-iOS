//
//  ConceptService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

protocol ConceptService {
    /// 컨셉의 목록을 불러오기
    func getStudioConcept() async throws -> [StudioConceptEntity]
    /// 컨셉에 해당하는 스튜디오 목록 불러오기
    func getConceptedStudioList(conceptedStudioRequest: ConceptedStudioRequest) async throws -> StudioEntity
}

final class DefaultConceptService: BaseService { }

extension DefaultConceptService: ConceptService {
    func getStudioConcept() async throws -> [StudioConceptEntity] {
        let fetchRequest = ConceptAPI.studioConcept
        
        let studioConceptArray = try await performRequest(
            fetchRequest,
            decodingType: [StudioConceptEntity].self
        )
        
        return studioConceptArray
    }
    
    func getConceptedStudioList(conceptedStudioRequest: ConceptedStudioRequest) async throws -> StudioEntity {
        let fetchRequest = ConceptAPI.conceptedStudioList(conceptedStudioRequest)
        
        let studioEntity = try await performRequest(
            fetchRequest,
            decodingType: StudioEntity.self
        )
        
        return studioEntity
    }
}
