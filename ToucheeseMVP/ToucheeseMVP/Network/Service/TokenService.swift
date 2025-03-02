//
//  TokenService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

protocol TokenService {
    /// 토큰 재발행
    func reissueToken(_ reissueTokenRequest: ReissueTokenRequest) async throws -> ReissueTokenResponse
    /// 소설 로그아웃 요청
    func postSocialLogout(_ deviceId: String) async throws -> String
}

final class DefualtTokenService: BaseService { }

extension DefualtTokenService: TokenService {
    func reissueToken(_ reissueTokenRequest: ReissueTokenRequest) async throws -> ReissueTokenResponse {
        let fetchRequest = TokenAPI.reissueToken(reissueTokenRequest)
        let response = try await performRequest(fetchRequest,
                                                decodingType: ReissueTokenResponse.self)
        
        return response
    }
    
    func postSocialLogout(_ deviceId: String) async throws -> String {
        print("Logout deviceId: \(deviceId)")
        let fetchReqeust = TokenAPI.socialLogout(deviceId: deviceId)
        let response = try await performRequest(fetchReqeust,
                                                decodingType: String.self)
        
        return response
    }
}
