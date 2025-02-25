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
            // 방출 타입을 AnyPublisher<Void, Never>로 변환
            .eraseToAnyPublisher()
    }
    
    // MARK: Posts
    /// 예약 내역 초기화 요청 함수
    func postRefreshReservation() {
        notificationCenter.post(name: .refreshReservation, object: nil)
    }
}

extension Notification.Name {
    /// 예약 내역 초기화 요청 이벤트
    static let refreshReservation = Notification.Name("refreshReservation")
}
