//
//  TempLoginViewModel.swift
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

final class TempLogInViewModel: LoginViewModelProtocol {
    // MARK: - Datas
    private let networkManager = NetworkManager.shared
    private let authManager = TempAuthenticationManager.shared

    // MARK: - Logics
    /// 카카오 로그인 처리
    func handleKakaoTalkLogin() async {
        // 카카오 로그인, 리턴 값으로 유저 정보 받아오기
        guard let kakaoUserInfo = await loginwithKakaoTalk() else { return }
        
        // 서버로 유저 정보 전송
        guard let response = await postKakaoUserInfoToServer(kakaoUserInfo: kakaoUserInfo) else { return }
        
        // postKakaoUserInfoToServer 응답값의 헤더의 accessToken에 접근
        guard let accessToken = response.headers["Authorization"]?.removeBearer else { return }
        
        // 키체인에 토큰 저장
        authManager.updateOrCreateTokens(
            accessToken: accessToken,
            refreshToken: response.kakaoLoginResponse.refreshToken,
            deviceId: response.kakaoLoginResponse.deviceId
        )
        
        // 유저 정보 갱신
        guard let userEmail = await getKakaoUserInfo()?.kakaoAccount?.email else { return }
        let memberId = response.kakaoLoginResponse.memberId
        let memberNickname = response.kakaoLoginResponse.nickname
        authManager.saveMemberInfo(memberNickname: memberNickname, memberEmail: userEmail, memberId: memberId)
                
        // 로그인 상태 갱신
        await authManager.successfulAuthentication()
    }
    
    /// 애플 로그인 처리
    func handleAppleLogin(_ authResults: ASAuthorization) async {
//         guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else { return }
//
//        let userID = appleIDCredential.user
//        let userFullName = (appleIDCredential.fullName?.familyName ?? "") + (appleIDCredential.fullName?.givenName ?? "")
//        let userEmail = appleIDCredential.email
//
//        print("========userID: \(userID)\n ========userFullName: \(userFullName)\n ==========userEmail: \(userEmail), ====name==\(appleIDCredential.fullName?.givenName)")
//
//         await postUserInfoToServer(.APPLE)
    }
    
    /// 카카오 로그인
    private func loginwithKakaoTalk() async -> OAuthToken? {
        do {
            let result = try await networkManager.loginWithKakaoTalk()
            return result
        } catch {
            print("카카오 로그인 에러 \(error)")
            return nil
        }
    }
    
    /// 카카오 유저 정보 가져오기
    private func getKakaoUserInfo() async -> User? {
        do {
            let userInfo = try await networkManager.fetchKakaoUserInfo()
            return userInfo
        } catch {
            print("유저 정보 가져오기 실패 \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// 서버로 사용자 정보 전송하기
    private func postKakaoUserInfoToServer(kakaoUserInfo: OAuthToken) async -> (kakaoLoginResponse: KakaoLoginResponse, headers: [String: String])? {
            do {
                guard let idToken = kakaoUserInfo.idToken else { return nil }
                
                // TODO: 키체인에서 가져와야 함?
                let deviceId: String? = nil
                
                let response = try await networkManager
                    .postKakaoUserInfoToServer(
                        KakaoLoginRequest(
                            idToken: idToken,
                            accessToken: kakaoUserInfo.accessToken,
                            platform: SocialType.KAKAO.rawValue,
                            deviceId: deviceId
                        )
                    )
                
                return response
            } catch {
                print("카카오 유저 정보 서버로 보내기 실패 \(error.localizedDescription)")
                return nil
            }
    }
}
