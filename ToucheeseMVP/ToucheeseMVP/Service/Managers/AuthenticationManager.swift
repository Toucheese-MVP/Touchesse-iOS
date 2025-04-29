//
//  AuthenticationManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 1/31/25.
//

import Foundation
import AuthenticationServices

enum AuthStatus {
    case notAuthenticated
    case authenticated
}

final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    private let keychainManager = KeychainManager.shared
    private lazy var tokenService = DefualtTokenService(session: SessionManager.shared.authSession)
    
    private init() {}
    
    @Published private(set) var authStatus: AuthStatus = .notAuthenticated
    @Published private(set) var memberNickname: String?
    @Published private(set) var memberEmail: String?
    
    private(set) var memberId: Int?
    
    var accessToken: String? {
        return KeychainManager.shared.read(forAccount: .accessToken)
    }
    var refreshToken: String? {
        return KeychainManager.shared.read(forAccount: .refreshToken)
    }
    var deviceID: String? {
        return KeychainManager.shared.read(forAccount: .deviceId)
    }
    
    var loginedPlatform: SocialType? {
        return (UserDefaultsManager.get(UserDefaultsKey.loginedPlatform) as String?)?.toSocialType()
    }
    
    // MARK: 코드 에러를 막기 위해 임시로 넣은 변수, 리팩토링을 통해 찜한 스튜디오 데이터를 어디서 관리할 것인지 고민해야 함
    var memberLikedStudios: [Studio] = []
    
    @MainActor
    func successfulAuthentication() {
        authStatus = .authenticated
        Task {
            try await postFCMToken()
        }
    }
    
    @MainActor
    func failedAuthentication() {
        authStatus = .notAuthenticated
    }
    
    /// 토큰 값을 키체인에 업데이트 하거나  저장하는 함수
    func updateOrCreateTokens(accessToken: String, refreshToken: String, deviceId: String) {
        keychainManager.updateOrCreateToken(token: accessToken, forAccount: .accessToken)
        keychainManager.updateOrCreateToken(token: refreshToken, forAccount: .refreshToken)
        keychainManager.updateOrCreateToken(token: deviceId, forAccount: .deviceId)
    }
    
    /// 로그인 후 멤버 정보 저장
    @MainActor
    func saveMemberInfo(memberNickname: String, memberEmail: String, memberId: Int) {
        self.memberNickname = memberNickname
        self.memberEmail = memberEmail
        self.memberId = memberId
    }
    
    /// 앱 시작 시 토큰과 로그인 상태를 확인하는 함수
    func initialCheckAuthStatus() async -> AuthStatus {
        /// 로그인된 플랫폼을 가져오거나 저장된 유저 디폴트 값이 없을 때 로그아웃 상태 리턴
        guard self.loginedPlatform != nil else {
            await failedAuthentication()
            return authStatus
        }
        
        /// 저장된 토큰을 가져오거나 저장된 토큰이 없을 경우 로그아웃 상태 리턴
        guard let tokens = getTokensFromKeychain() else {
            await failedAuthentication()
            return authStatus
        }
        
        /// 토큰 재발행 요청, 실패 시 로그아웃 상태 리턴
        guard let reissueTokenResponse = await requestReissueTokenToServer(refreshToken:tokens.refreshToken, deviceId: tokens.deviceId) else {
            // Refresh 토큰이 만료된 경우 - 기존 데이터 삭제(로그아웃 처리)
            await resetAllAuthDatas()
            return authStatus
        }
        
        /// reissueTokenResponse 헤더의 accessToken 접근
        guard let accessToken = reissueTokenResponse.headers?["Authorization"]?.removeBearer else {
            await failedAuthentication()
            return authStatus
        }
                
        // MARK: 로그인 상태
        /// 계정 정보 업데이트
        await updateAuthenticationInfo(reissueTokenResponse, accessToken)
        
        /// 로그인 상태로 변경
        await successfulAuthentication()
        
        return authStatus
    }
    
    /// 모든 계정 정보 초기화
    @MainActor
    func resetAllAuthDatas() {
        memberNickname = nil
        memberEmail = nil
        memberId = nil
    
        keychainManager.delete(forAccount: .accessToken)
        keychainManager.delete(forAccount: .refreshToken)
        keychainManager.delete(forAccount: .deviceId)
        
        UserDefaultsManager.remove(.loginedPlatform)
        SessionManager.shared.resetSession()
        
        failedAuthentication()
    }
    
    /// 뷰모델 정보 초기화
    func resetViewModel() {
        NotificationManager.shared.postResetQuestion()
        NotificationManager.shared.postResetReservation()
    }
    
    /// 토큰 갱신
    @MainActor
    func reissueToken() async {
        /// 저장된 토큰을 가져오거나 저장된 토큰이 없을 경우 리턴
        guard let tokens = getTokensFromKeychain() else {
            return
        }
        
        /// 토큰 재발행 요청, 실패 시 리턴
        guard let reissueTokenResponse = await requestReissueTokenToServer(refreshToken:tokens.refreshToken, deviceId: tokens.deviceId) else {
            return
        }
        
        /// reissueTokenResponse 헤더의 accessToken 접근
        guard let accessToken = reissueTokenResponse.headers?["Authorization"]?.removeBearer else {
            return
        }
                
        /// 계정 정보 업데이트
        updateAuthenticationInfo(reissueTokenResponse, accessToken)
    }
    
    
    /// 키체인에 저장된 토큰을 가져오는 함수
    private func getTokensFromKeychain() -> (refreshToken: String, deviceId: String)? {
        guard let refreshToken = keychainManager.read(forAccount: .refreshToken) else { return nil }
        guard let deviceId = keychainManager.read(forAccount: .deviceId) else { return nil }
        
        return (refreshToken, deviceId)
    }
    
    /// 서버에 토큰 재발행을 요청하는 함수
    private func requestReissueTokenToServer(refreshToken: String, deviceId: String) async -> ReissueTokenResponse? {
        let request = ReissueTokenRequest(refreshToken: refreshToken, deviceId: deviceId)
            
        do {
            // let response = try await networkManager.reissueToken(request)
            let response = try await tokenService.reissueToken(request)
            return response
        } catch {
            print("reissueToken error:\(error.localizedDescription)")
            return nil
        }
    }
    
    /// 토큰 재발행 성공 후 계정 정보 업데이트
    @MainActor
    private func updateAuthenticationInfo(_ reissueTokenResponse: ReissueTokenResponse, _ accessToken: String) {
        saveMemberInfo(memberNickname: reissueTokenResponse.name, memberEmail: reissueTokenResponse.email, memberId: reissueTokenResponse.memberId)
        updateOrCreateTokens(accessToken: accessToken, refreshToken: reissueTokenResponse.refreshToken, deviceId: reissueTokenResponse.deviceId)
    }
    
    private func postFCMToken() async throws {
        // fcm token 서버에 전송
        guard let token = KeychainManager.shared.read(forAccount: .fcmToken) else { return }
        do {
            try await DefaultFCMService(session: SessionManager.shared.authSession)
                .postFCMToken(token: token)
        } catch {
            print("Post FCM token Error: \(error)")
        }
    }
}



//    /// 애플 회원탈퇴를 위한 authorizationCode를 가져오는 함수
//    /// - 기기가 로그아웃 상태일 시 nil 리턴
//    private func getAuthorizationCode(
//        controller: ASAuthorizationController,
//        didCompleteWithAuthorization authorization: ASAuthorization
//    ) -> String? {
//        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return nil }
//        guard let authorizationCodeData = appleIDCredential.authorizationCode else { return nil }
//        guard let authorizationCodeString = String(data: authorizationCodeData, encoding: .utf8) else { return nil }
//
//        return authorizationCodeString
//    }

//class LoginModel: NSObject {
//    func loginApple() {
//        // 애플 로그인 요청시 사용되는 객체
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//        
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
//}
//
//extension LoginModel: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
//        
//    }
//}
//
//extension LoginModel: ASAuthorizationControllerPresentationContextProviding {
//    /// 로그인 화면을 띄울 창을 설정
//    // UIApplication.shared.connectedScenes = 현재 앱에서 활성화된 모든 UIScene
//    // .first(where: )로 첫번째 UIScene을 가져옴
//    // 화면을 띄울 수 있는 UIWindowScene으로 타입 캐스팅
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {$0 is UIWindowScene }) as? UIWindowScene,
//              let window = windowScene.windows.first else {
//            fatalError("No valid window found")
//        }
//        
//        return window
//    }
//}
