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
    /// 예약 내역 초기화 요청 정의
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
    
    /// 문의 내역 초기화 요청 정의
    var refreshQuestionPublisher: AnyPublisher<Void, Never> {
        notificationCenter.publisher(for: .refreshQuestion)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    // MARK: Posts
    /// 예약 내역 초기화 요청 함수
    func postRefreshReservation() {
        notificationCenter.post(name: .refreshReservation, object: nil)
    }
    
    /// 문의 내역 초기화 요청 함수
    func postRefreshQuestion() {
        notificationCenter.post(name: .refreshQuestion, object: nil)
    }
}

extension Notification.Name {
    /// 예약 내역 초기화 요청 이벤트
    static let refreshReservation = Notification.Name("refreshReservation")
    
    /// 문의 내역 초기화 요청 이벤트
    static let refreshQuestion = Notification.Name("refreshQuestion")
}

