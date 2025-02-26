//
//  AuthService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

protocol AuthService {
    /// 카카오 로그인
    func loginWithKakaoTalk() async throws -> OAuthToken
    /// 카카오 사용자 정보 가져오기
    func fetchKakaoUserInfo() async throws -> User
    /// 카카오 유저 정보를 서버에 전송
    func postKakaoUserInfoToServer(_ kakaoLoginRequest: KakaoLoginRequest) async throws -> SocialLoginResponse
    /// 애플 유저 정보를 서버에 전송
    func postAppleUserInfoToServer(_ appleLoginRequest: AppleLoginRequest) async throws -> SocialLoginResponse
}

final class DefualtAuthService: BaseService { }

extension DefualtAuthService: AuthService {
    // 카카오 로그인 Wrapping
    @MainActor
    func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            // 토큰이나 에러를 처리하는 핸들러
            let resultHandler: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
            
            // 카카오톡 앱으로 로그인이 가능한 경우
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: resultHandler)
            } else {
                // 웹으로 로그인 해야하는 경우
                UserApi.shared.loginWithKakaoAccount(completion: resultHandler)
            }
        }
    }
    
    // 카카오 사용자 정보 가져오기 Wrapping
    func fetchKakaoUserInfo() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
    
    /// 카카오 유저 정보를 서버에 전송
    func postKakaoUserInfoToServer(_ kakaoLoginRequest: KakaoLoginRequest) async throws -> SocialLoginResponse {
        let fetchRequest = AuthAPI.kakaoLogin(kakaoLoginRequest)
        
        let response = try await performRequest(
            fetchRequest,
            decodingType: SocialLoginResponse.self
        )
        
        return response
    }
    
    /// 애플 유저 정보를 서버에 전송
    func postAppleUserInfoToServer(_ appleLoginRequest: AppleLoginRequest) async throws -> SocialLoginResponse {
        let fetchRequest = AuthAPI.appleLogin(appleLoginRequest)
        
        let response = try await performRequest(
            fetchRequest,
            decodingType: SocialLoginResponse.self
        )
        
        return response
    }
}
