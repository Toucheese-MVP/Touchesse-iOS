//
//  AuthenticationManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 1/31/25.
//

import Foundation

enum AuthStatus {
    case notAuthenticated
    case authenticated
}

final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    private let networkManager = NetworkManager.shared
    private let keychainManager = KeychainManager.shared
    
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
    
    // MARK: 코드 에러를 막기 위해 임시로 넣은 변수, 리팩토링을 통해 찜한 스튜디오 데이터를 어디서 관리할 것인지 고민해야 함
    var memberLikedStudios: [Studio] = []
    
    @MainActor
    func successfulAuthentication() {
        authStatus = .authenticated
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
    func saveMemberInfo(memberNickname: String, memberEmail: String, memberId: Int) {
        self.memberNickname = memberNickname
        self.memberEmail = memberEmail
        self.memberId = memberId
    }
    
    /// 앱 시작 시 토큰과 로그인 상태를 확인하는 함수
    func initialCheckAuthStatus() async -> AuthStatus {
        /// 저장된 토큰을 가져오거나 저장된 토큰이 없을 경우 로그아웃 상태 리턴
        guard let tokens = getTokensFromKeychain() else {
            await failedAuthentication()
            return authStatus
        }
        
        /// 토큰 재발행 요청, 실패 시 로그아웃 상태 리턴
        guard let reissueTokenResponse = await reissueToken(refreshToken:tokens.refreshToken, deviceId: tokens.deviceId) else {
            // Refresh 토큰이 만료된 경우 - 기존 데이터 삭제(로그아웃 처리)
            deleteAllAuthDatas()
            await failedAuthentication()
            return authStatus
        }
        
        /// reissueTokenResponse 헤더의 accessToken 접근
        guard let accessToken = reissueTokenResponse.headers?["Authorization"]?.removeBearer else {
            await failedAuthentication()
            return authStatus
        }
                
        // MARK: 로그인 상태
        /// 계정 정보 업데이트
        updateAuthenticationInfo(reissueTokenResponse, accessToken)
        
        /// 로그인 상태로 변경
        await successfulAuthentication()
        
        return authStatus
    }
    
    /// 키체인에 저장된 토큰을 가져오는 함수
    private func getTokensFromKeychain() -> (refreshToken: String, deviceId: String)? {
        guard let refreshToken = keychainManager.read(forAccount: .refreshToken) else { return nil }
        guard let deviceId = keychainManager.read(forAccount: .deviceId) else { return nil }
        
        return (refreshToken, deviceId)
    }
    
    /// 서버에 토큰 재발행을 요청하는 함수
    private func reissueToken(refreshToken: String, deviceId: String) async -> ReissueTokenResponse? {
        let request = ReissueTokenRequest(refreshToken: refreshToken, deviceId: deviceId)
        
        do {
            let response = try await networkManager.reissueToken(request)
            return response
        } catch {
            print("reissueToken error:\(error.localizedDescription)")
            return nil
        }
    }
    
    /// 토큰 재발행 성공 후 계정 정보 업데이트
    private func updateAuthenticationInfo(_ reissueTokenResponse: ReissueTokenResponse, _ accessToken: String) {
        saveMemberInfo(memberNickname: reissueTokenResponse.name, memberEmail: reissueTokenResponse.email, memberId: reissueTokenResponse.memberId)
        updateOrCreateTokens(accessToken: accessToken, refreshToken: reissueTokenResponse.refreshToken, deviceId: reissueTokenResponse.deviceId)
    }
    
    /// 모든 계정 정보 삭제
    private func deleteAllAuthDatas() {
        memberNickname = nil
        memberEmail = nil
        memberId = nil
    
        keychainManager.delete(forAccount: .accessToken)
        keychainManager.delete(forAccount: .refreshToken)
        keychainManager.delete(forAccount: .deviceId)
    }
}
