//
//  AuthAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    // 소셜 로그인
    case kakaoLogin(KakaoLoginRequest)
    case appleLogin(AppleLoginRequest)
}

extension AuthAPI: TargetType {
    
    static var apiType: APIType = .auth
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/kakao"
        case .appleLogin:
            return "/apple"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .kakaoLogin, .appleLogin:
            return .post
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .kakaoLogin, .appleLogin:
            HeaderType.json.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .kakaoLogin, .appleLogin:
            EncodingType.post.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .kakaoLogin(let kakaoLoginRequest):
            var params: Parameters = [:]
            
            params["idToken"] = kakaoLoginRequest.idToken
            params["accessToken"] = kakaoLoginRequest.accessToken
            params["platform"] = kakaoLoginRequest.platform
            params["deviceId"] = kakaoLoginRequest.deviceId
            
            return params
            
        case .appleLogin(let appleLoginRequest):
            var params: Parameters = [:]
            
            params["idToken"] = appleLoginRequest.idToken
            params["platform"] = appleLoginRequest.platform
            params["deviceId"] = appleLoginRequest.deviceId
            
            return params
        }
    }
}
