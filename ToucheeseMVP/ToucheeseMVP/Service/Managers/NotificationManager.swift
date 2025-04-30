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
}

// MARK: Publisher
extension NotificationManager {
    /// 로그인 이벤트 방출 정의
    var loginPublisher: AnyPublisher<Token, Never> {
        notificationCenter.publisher(for: .loginEvent)
            .compactMap{ $0.token }
            .eraseToAnyPublisher()
    }
    
    /// 로그아웃 이벤트 방출 정의
    var logoutPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .logoutEvent)
            .map{ _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 스튜디오 예약 이벤트 방출 정의
    var reservationPublusher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .reservationEvent)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 스튜디오 예약 취소 이벤트 방출 정의
    var cancelReservationPublusher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .cancelReservationEvent)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 문의 이벤트 방출 정의
    var questionPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .questionEvent)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

// MARK: Post
extension NotificationManager {
    /// 로그인 이벤트를 발생시킵니다.
    func postLoginEvent(token: Token) {
        notificationCenter.post(name: .loginEvent, object: token)
    }
    
    /// 로그아웃 이벤트를 발생시킵니다.
    func postLogoutEvent() {
        notificationCenter.post(name: .logoutEvent, object: nil)
    }
    
    /// 스튜디오 예약 이벤트를 발생시킵니다.
    func postReservationEvent() {
        notificationCenter.post(name: .reservationEvent, object: nil)
    }
    
    /// 스튜디오 예약 취소 이벤트를 발생시킵니다.
    func postCancelReservationEvent() {
        notificationCenter.post(name: .cancelReservationEvent, object: nil)
    }
    
    /// 문의 이벤트를 발생시킵니다.
    func postQuestionEvent() {
        notificationCenter.post(name: .questionEvent, object: nil)
    }
}

// MARK: Event name
extension Notification.Name {
    /// 로그인 / 로그아웃 이벤트
    static let loginEvent = Notification.Name("loginEvent")
    static let logoutEvent = Notification.Name("logoutEvent")
    
    /// 스튜디오 예약 / 취소 이벤트
    static let reservationEvent = Notification.Name("reservationEvent")
    static let cancelReservationEvent = Notification.Name("cancelReservationEvent")
    
    /// 문의 내역 초기화 요청 이벤트
    static let questionEvent = Notification.Name("questionEvent")
}

extension Notification {
    var token: Token? {
        return object as? Token
    }
}
