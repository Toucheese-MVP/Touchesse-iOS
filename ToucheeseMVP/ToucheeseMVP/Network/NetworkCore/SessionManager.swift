//
//  SessionManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire

final class SessionManager {
    static let shared = SessionManager()
    
    /// 인증이 필요한 세션
    /// - 인터셉터가 헤더에 accessToken을 적용
    /// - 인터셉터가 토큰 재발급 처리
    let authSession: Session
    
    /// 기본 세션
    let baseSession: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        // 서버 응답이 10초 이상 걸리면 요청 취소
        configuration.timeoutIntervalForRequest = 10
        // 전체 네트워크 작업 시간을 10초로 설정
        configuration.timeoutIntervalForResource = 10
        // 캐시를 무시하고 항상 서버에서 최신 데이터를 가져옴
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.authSession = Session(configuration: configuration, interceptor: AuthInterceptor(), eventMonitors: [LoggingEventMonitor()])
        self.baseSession = Session(configuration: configuration, eventMonitors: [LoggingEventMonitor()])
    }
}
