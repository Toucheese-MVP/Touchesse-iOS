//
//  StudioRegion.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/17/24.
//

import Foundation

enum StudioRegion: Int, OptionType, CaseIterable {
    case all = 0
    case gangnam
    case seocheo
    case songpa
    case gangseo
    case mapo
    case yeongdeungpo
    case gangbuk
    case yongsan
    case seongdong
    
    var id: Int { self.rawValue }
    var title: String {
        switch self {
        case .all: "전체"
        case .gangnam: "강남구"
        case .seocheo: "서초구"
        case .songpa: "송파구"
        case .gangseo: "강서구"
        case .mapo: "마포구"
        case .yeongdeungpo: "영등포구"
        case .gangbuk: "강북구"
        case .yongsan: "용산구"
        case .seongdong: "성동구"
        }
    }
}
