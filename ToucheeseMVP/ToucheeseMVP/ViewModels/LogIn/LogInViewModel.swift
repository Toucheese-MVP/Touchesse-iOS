//
//  LogInViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/1/25.
//

import Foundation

import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

protocol LoginViewModelProtocol: ObservableObject {
    /// 카카오 로그인 처리
    func handleKakaoTalkLogin() async
    /// 애플 로그인 처리
    func handleAppleLogin(_ authResults: ASAuthorization) async
}

final class LogInViewModel: LoginViewModelProtocol {
    // MARK: - Datas
    private let authManager = AuthenticationManager.shared
    private let keychainManager = KeychainManager.shared
    private let authService = DefualtAuthService(session: SessionManager.shared.authSession)

    // MARK: - Logics
    /// 카카오 로그인 처리
    // MARK: TODO: handleKakaoTalkLogin과 handleAppleLogin 파라미터로 소셜 로그인 타입을 받아서 하나로 합칠 수 있을듯
    func handleKakaoTalkLogin() async {
        // 카카오 로그인, 리턴 값으로 유저 정보 받아오기
        guard let kakaoUserInfo = await loginwithKakaoTalk() else { return }
        
        // 서버로 유저 정보 전송
        guard let response = await postKakaoUserInfoToServer(kakaoUserInfo: kakaoUserInfo) else { return }
        
        // 소셜 로그인 응답값 처리
        await handleSocialLogigResponse(response, SocialType.KAKAO)
    }
    
    /// 애플 로그인 처리
    func handleAppleLogin(_ authResults: ASAuthorization) async {
        // 애플 ID 정보
        guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else { return }
        
        // 서버로 유저 정보 전송
        guard let response = await postAppleUserInfoToServer(appleUserInfo: appleIDCredential) else { return }
        
        // 소셜 로그인 응답값 처리
        await handleSocialLogigResponse(response, SocialType.APPLE)
    }
    
    /// 카카오 로그인
    private func loginwithKakaoTalk() async -> OAuthToken? {
        do {
            let result = try await authService.loginWithKakaoTalk()
            return result
        } catch {
            print("카카오 로그인 에러 \(error)")
            return nil
        }
    }
    
    /// 카카오 유저 정보 가져오기
    private func getKakaoUserInfo() async -> User? {
        do {
            let userInfo = try await authService.fetchKakaoUserInfo()
            return userInfo
        } catch {
            print("유저 정보 가져오기 실패 \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// 서버로 사용자 정보 전송하기
    private func postKakaoUserInfoToServer(kakaoUserInfo: OAuthToken) async -> SocialLoginResponse? {
            do {
                guard let idToken = kakaoUserInfo.idToken else { return nil }
            
                let response = try await authService
                    .postKakaoUserInfoToServer(
                        KakaoLoginRequest(
                            idToken: idToken,
                            accessToken: kakaoUserInfo.accessToken,
                            platform: SocialType.KAKAO.rawValue,
                            deviceId: keychainManager.read(forAccount: .deviceId)))
                
                return response
            } catch {
                print("카카오 유저 정보 서버로 보내기 실패 \(error.localizedDescription)")
                return nil
            }
    }
    
    /// 서버로 사용자 정보 전송하기
    private func postAppleUserInfoToServer(appleUserInfo: ASAuthorizationAppleIDCredential) async -> SocialLoginResponse? {
        do {
            // 토큰 데이터 가져오기
            guard let idToken = appleUserInfo.identityToken,
                  let idTokenString = String(data: idToken, encoding: .utf8) else {
                print("Error: identityToken Error(nil or String conversion failed)")
                return nil
            }
                        
            let response = try await authService
                .postAppleUserInfoToServer(
                    AppleLoginRequest(idToken: idTokenString,
                                      platform: SocialType.APPLE.rawValue,
                                      deviceId: keychainManager.read(forAccount: .deviceId)))
            
            return response
        } catch {
            print("애플 유저 정보 서버로 보내기 실패 \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 소셜 로그인 응답값 처리
    ///  1. 키체인에 토큰 저장
    ///  2. 유저 정보 갱신
    ///  3. 로그인 플랫폼 갱신
    ///  4. 로그인 상태 갱신
    private func handleSocialLogigResponse(_ socialLoginRespons: SocialLoginResponse, _ socialType: SocialType) async {
        // 응답값의 헤더의 accessToken에 접근
        guard let accessToken = socialLoginRespons.headers?["Authorization"]?.removeBearer else { return }
        
        // 키체인에 토큰 저장
        authManager.updateOrCreateTokens(
            accessToken: accessToken,
            refreshToken: socialLoginRespons.refreshToken,
            deviceId: socialLoginRespons.deviceId
        )
        
        // 유저 정보 갱신
        await authManager.saveMemberInfo(memberNickname: socialLoginRespons.nickname,
                                   memberEmail: socialLoginRespons.email,
                                   memberId: socialLoginRespons.memberId)
        
        // 로그인 플랫폼 갱신
        UserDefaultsManager.set(socialType.rawValue, for: UserDefaultsKey.loginedPlatform)
                
        // 로그인 상태 갱신
        await authManager.successfulAuthentication()
    }
}
