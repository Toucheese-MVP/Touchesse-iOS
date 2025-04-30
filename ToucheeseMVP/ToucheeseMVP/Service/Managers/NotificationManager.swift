//
//  NotificationManager.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/24/25.
//

import Foundation
import Combine

final class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = NotificationCenter.default
    
    private init() {}
    
    // MARK: Publishers
    /// 예약 내역 refresh 요청 정의
    var refreshReservationPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .refreshReservation)
            // 방출 값 Void로 변경(방출 타입은 Map<NotificationCenter.Publisher, Void>)(.publisher는 Notification.Publisher 객체를 방출)
            .map { _ in () }
            /*
             방출 타입을 AnyPublisher<Void, Never>로 변환
             (Void를 방출하고, 에러는 발생하지 않는 Publisher 라는 의미만 갖는 추상 타입)
             타입 은닉(type erasure)을 하기 위한 메서드
             사용하지 않으면 외부에 Map<NotificationCenter.Publisher, Void>)로 보이므로
             내부 코드를 수정하면 구현부에서도 수정해야될수도 있음
             */
            .eraseToAnyPublisher()
    }
    
    /// 예약 내역 초기화 요청 정의
    var resetReservationPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .resetReservation)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 문의 내역 refresh 요청 정의
    var refreshQuestionPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .refreshQuestion)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 문의 내역 초기화 요청 정의
    var resetQuestionPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .resetQuestion)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 로그인 이벤트 방출 정의
    var loginEventPublisher: AnyPublisher<Token, Never> {
        notificationCenter.publisher(for: .loginEvent)
            .compactMap{ $0.token }
            .eraseToAnyPublisher()
    }
    
    /// 로그아웃 이벤트 방출 정의
    var logoutEventPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .logoutEvent)
            .map{ _ in () }
            .eraseToAnyPublisher()
    }
    
    // MARK: Posts
    /// 예약 내역 refresh 요청 함수
    func postRefreshReservation() {
        notificationCenter.post(name: .refreshReservation, object: nil)
    }
    
    /// 예약 내역 초기화 요청 함수
    func postResetReservation() {
        notificationCenter.post(name: .resetReservation, object: nil)
    }
    
    /// 문의 내역 refresh 요청 함수
    func postRefreshQuestion() {
        notificationCenter.post(name: .refreshQuestion, object: nil)
    }
    
    /// 문의 내역 초기화 요청 함수
    func postResetQuestion() {
        notificationCenter.post(name: .resetQuestion, object: nil)
    }
    
    /// 로그인 이벤트를 발생시킵니다.
    func postLoginEvent(token: Token) {
        notificationCenter.post(name: .loginEvent, object: token)
    }
    
    /// 로그아웃 이벤트를 발생시킵니다.
    func postLogoutEvent() {
        notificationCenter.post(name: .logoutEvent, object: nil)
    }
}

extension Notification.Name {
    /// 예약 내역 초기화 요청 이벤트
    static let refreshReservation = Notification.Name("refreshReservation")
    static let resetReservation = Notification.Name("resetReservation")
    
    /// 문의 내역 초기화 요청 이벤트
    static let refreshQuestion = Notification.Name("refreshQuestion")
    static let resetQuestion = Notification.Name("resetQuestion")
    
    /// 로그인 / 로그아웃 이벤트
    static let loginEvent = Notification.Name("loginEvent")
    static let logoutEvent = Notification.Name("logoutEvent")
}

extension Notification {
    var token: Token? {
        return object as? Token
    }
}
