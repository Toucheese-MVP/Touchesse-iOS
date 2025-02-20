//
//  ConceptAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum ConceptAPI {
    /// 전체 컨셉 목록을 불러오기
    case studioConcept
    /// 컨셉에 해당하는 스튜디오 목록을 불러오기
    case conceptedStudioList(ConceptedStudioRequest)
}

extension ConceptAPI: TargetType {
    
    static var apiType: APIType = .concept
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .studioConcept:
            return ""
        case .conceptedStudioList(let conceptedStudioRequest):
            if conceptedStudioRequest.location == [] && conceptedStudioRequest.price == nil && conceptedStudioRequest.rating == nil {
                return "/\(conceptedStudioRequest.studioConceptId)/studios?"
            } else {
                return "/\(conceptedStudioRequest.studioConceptId)/studios/filters?"
            }
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .studioConcept, .conceptedStudioList:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .studioConcept, .conceptedStudioList:
            HeaderType.json.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .studioConcept, .conceptedStudioList:
            EncodingType.get.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .studioConcept:
            return [:]
            
        case .conceptedStudioList(let conceptedStudioRequest):
            var params: Parameters = [:]
            
            params["page"] = conceptedStudioRequest.page
            
            if let price = conceptedStudioRequest.price {
                params["price"] = price
            }
            
            if let rating = conceptedStudioRequest.rating {
                params["rating"] = rating
            }
            
            if let location = conceptedStudioRequest.location {
                params["locations"] = location
            }
            
            return params
        }
    }
}
