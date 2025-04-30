//
//  SessionManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire
import Combine

final class SessionManager {
    static let shared = SessionManager()
    private var cancellables = Set<AnyCancellable>()
    
    /// 인증이 필요한 세션
    /// - 인터셉터가 헤더에 accessToken을 적용
    /// - 인터셉터가 토큰 재발급 처리
    var authSession: Session = Session()
    
    /// 기본 세션
    var baseSession: Session = Session()

    private init() {
        setInitialSession()
        subscribeLoginEvent()
        subscribeLogoutEvent()
    }
}

extension SessionManager {
    /// 로그인 이벤트 구독
    func subscribeLoginEvent() {
        NotificationManager.shared.loginEventPublisher
            .sink { [weak self] token in
                self?.handleLoginEvent(token: token)
            }
            .store(in: &cancellables)
    }
    
    /// 로그아웃 이벤트 구독
    func subscribeLogoutEvent() {
        NotificationManager.shared.logoutEventPublisher
            .sink { [weak self] _ in
                self?.handleLogoutEvent()
            }
            .store(in: &cancellables)
    }
    
    /// 로그인 이벤트 처리
    ///
    /// 전달받은 accessToken과 refreshToken으로 authSession 생성, 업데이트
    private func handleLoginEvent(token: Token) {
        self.authSession = makeSession(accessToken: token.accessToken, refreshToken: token.refreshToken)
    }
    
    /// 로그아웃 이벤트 처리
    ///
    /// 빈 accessToken과 빈 refreshToken을 가진 authSession 생성, 업데이트
    private func handleLogoutEvent() {
        self.authSession = makeSession(accessToken: "", refreshToken: "")
    }
    
    /// 기본 세션 초기화
    private func setInitialSession() {
        self.authSession = makeSession(accessToken: "", refreshToken: "")
        self.baseSession = makeSession(accessToken: "", refreshToken: "", useInterceptor: false)
    }
    
    /// 세션 생성
    private func makeSession(accessToken: String, refreshToken: String, useInterceptor: Bool = true) -> Session {
        var interceptor: RequestInterceptor? = nil
        
        // 인터셉터 정의
        if useInterceptor {
            interceptor = AuthenticationInterceptor(
                authenticator: TokenAuthenticator(),
                credential: TokenAuthCredential(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    requiresRefresh: false
                )
            )
        }

        return Session(
            configuration: makeConfiguration(),
            interceptor: interceptor,
            eventMonitors: [LoggingEventMonitor()]
        )
    }
    
    /// 기본 URLSessionConfiguration 생성
    private func makeConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        // 서버 응답이 10초 이상 걸리면 요청 취소
        configuration.timeoutIntervalForRequest = 10
        // 전체 네트워크 작업 시간을 10초로 설정
        configuration.timeoutIntervalForResource = 10
        // 캐시를 무시하고 항상 서버에서 최신 데이터를 가져옴
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        return configuration
    }
}
