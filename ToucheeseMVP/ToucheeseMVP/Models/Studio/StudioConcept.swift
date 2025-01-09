//
//  StudioConcept.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation

enum StudioConcept: Int {
    /// 플래쉬 터진 느낌
    case flashIdol = 1
    /// 생동감 있는 실물 느낌
    case liveliness
    /// 블랙/블루 배우 느낌
    case blackBlueActor
    /// 내추럴 화보 느낌
    case naturalPictorial
    /// 수채화 그림체 느낌
    case waterColor
    /// 화려한 느낌
    case gorgeous
    
    var title: String {
        switch self {
        case .flashIdol: "플래쉬 터진"
        case .liveliness: "생동감 있는 실물"
        case .blackBlueActor: "블랙/블루 배우"
        case .naturalPictorial: "내추럴 화보"
        case .waterColor: "수채화 그림체"
        case .gorgeous: "화려한"
        }
    }
}
