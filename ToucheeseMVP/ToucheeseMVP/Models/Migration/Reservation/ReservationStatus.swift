//
//  ReservationStatus.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation
import SwiftUICore

enum ReservationStatus: Decodable, CaseIterable {
    case waiting
    case confirm
    case cancel
    case complete
    
    var title: String {
        switch self {
        case .waiting: "예약접수"
        case .confirm: "예약확정"
        case .cancel: "예약취소"
        case .complete: "촬영완료"
        }
    }
    
    var description: String {
        switch self {
        case .waiting: "스튜디오에 예약을 신청한 상태입니다. 스튜디오에서 사용자가 신청한 예약을 확인 후 예약 완료나 예약 취소 상태로 변경됩니다."
        case .confirm: "스튜디오에서 예약을 완료한 상태입니다. 예약 날짜에 촬영을 진행하면 됩니다. 사용자가 예약을 취소할 수도 있습니다."
        case .cancel: "스튜디오에서 예약을 취소한 상태입니다. 다른 날짜나 시간으로 예약을 다시 진행해야 합니다."
        // TODO: - 추후 리뷰 작성 기능이 들어가면 리뷰 작성 가능하다고 설명해주기
        case .complete: "사용자가 예약한 시간에 촬영이 완료된 상태입니다."
        }
    }
    
    var color: (font: Color, background: Color, stroke: Color) {
        switch self {
        case .waiting: (.tcGray09, .tcGray03, .tcGray03)
        case .confirm: (.tcPrimary07, .clear, .tcPrimary07)
        case .cancel: (.tcError, .clear, .tcError)
        case .complete: (.tcGray09, .tcPrimary05, .tcPrimary05)
        }
    }
    
    /// title을 통해서 enum case 찾기
    init(title: String) {
        if let status = ReservationStatus.allCases.first(where: { $0.title == title }) {
            self = status
        } else {
            self = .waiting
        }
    }
}
