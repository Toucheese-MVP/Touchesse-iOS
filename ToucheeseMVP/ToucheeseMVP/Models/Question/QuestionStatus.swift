//
//  QuestionStatus.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/21/25.
//

import Foundation

enum QuestionStatus {
    case waiting
    case complete
    
    var title: String {
        switch self {
        case .waiting: "답변 대기"
        case .complete: "답변 완료"
        }
    }
}
