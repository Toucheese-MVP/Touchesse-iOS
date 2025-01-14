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
    case seodaemun
    case seongbuk
    case yangcheon
    case dongdaemun
    case gwangjin
    case geumcheon
    case gangdong
    case junglang
    case geonglo
    
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
        case .seodaemun: "서대문구"
        case .seongbuk: "성북구"
        case .yangcheon: "양천구"
        case .dongdaemun: "동대문"
        case .gwangjin: "광진구"
        case .geumcheon: "금천구"
        case .gangdong: "강동구"
        case .junglang: "중랑구"
        case .geonglo: "종로구"
        }
    }
    
    var querryParameter: String {
        String(title.dropLast())
    }
}
