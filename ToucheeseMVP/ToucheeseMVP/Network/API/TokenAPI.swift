//
//  TokenAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum TokenAPI {
    // 소셜 로그아웃
    case socialLogout(deviceId: String)
    // 토큰 재발급
    case reissueToken(ReissueTokenRequest)
}

extension TokenAPI: TargetType {
    static var apiType: APIType = .token
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .socialLogout:
            return "/logout"
        case .reissueToken:
            return "/reissue"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .socialLogout:
            return .delete
        case .reissueToken:
            return .post
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .socialLogout:
            HeaderType.jsonWithAccessToken.value
        case .reissueToken:
            HeaderType.json.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .socialLogout:
            EncodingType.delete.value
        case .reissueToken:
            EncodingType.post.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .socialLogout(let deviceId):
            var params: Parameters = [:]
            
            params["deviceId"] = deviceId
            
            return params
            
        case .reissueToken(let reissueTokenRequest):
            var params: Parameters = [:]
            
            params["refreshToken"] = reissueTokenRequest.refreshToken
            params["deviceId"] = reissueTokenRequest.deviceId
            
            return params
        }
    }
}
