//
//  AuthenticationManager.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/23/24.
//

import Foundation

enum AuthStatus {
    case notAuthenticated
    case authenticated
}


final class AuthenticationManager: ObservableObject {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    @Published private(set) var authStatus: AuthStatus = .notAuthenticated
    
    var accessToken: String? {
        return KeychainManager.shared.read(forAccount: .accessToken)
    }
    var refreshToken: String? {
        return KeychainManager.shared.read(forAccount: .refreshToken)
    }
    
    var memberId: Int?
    @Published var memberNickname: String?
    var memberLikedStudios: [Studio] = []
    
    @MainActor
    func successfulAuthentication() {
        authStatus = .authenticated
    }
    
    @MainActor
    func failedAuthentication() {
        authStatus = .notAuthenticated
    }
    
    @MainActor
    func logout() {
        memberId = nil
        memberNickname = nil
        memberLikedStudios = []
        
        KeychainManager.shared.delete(forAccount: .accessToken)
        KeychainManager.shared.delete(forAccount: .refreshToken)
        
        authStatus = .notAuthenticated
    }
    
    @MainActor
    func withdrawal() {
        memberId = nil
        memberNickname = nil
        memberLikedStudios = []
        
        KeychainManager.shared.delete(forAccount: .accessToken)
        KeychainManager.shared.delete(forAccount: .refreshToken)
        
        authStatus = .notAuthenticated
    }
    
}
