//
//  StudioConcept.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation

enum StudioConcept: Int {
    /// 생동감 있는 실물 느낌
    case liveliness = 1
    /// 플래쉬/아이돌 느낌
    case flashIdol
    /// 흑백/블루 배우 느낌
    case blackBlueActor
    /// 내추럴 화보 느낌
    case naturalPictorial
    /// 선명하고 인형같은 느낌
    case gorgeous
    /// 필터/수채화 그림체 느낌
    case waterColor
  
    
    var title: String {
        switch self {
        case .liveliness: "생동감 있는 실물"
        case .flashIdol: "플래쉬 터진"
        case .blackBlueActor: "블랙/블루 배우"
        case .naturalPictorial: "내추럴 화보"
        case .gorgeous: "선명하고 인형같은"
        case .waterColor: "필터/수채화 그림체"
        }
    }
}
