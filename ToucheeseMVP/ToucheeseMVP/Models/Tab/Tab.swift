//
//  Tab.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import SwiftUI

enum Tab: CaseIterable {
    case home
    case reservation
//    case likedStudios
    case myPage
}

extension Tab {
    var title: String {
        switch self {
        case .home: return "홈"
        case .reservation: return "예약일정"
//        case .likedStudios: return "찜"
        case .myPage: return "내정보"
        }
    }
    
    var iconImage: (selected: ImageResource, unselected: ImageResource) {
        switch self {
        case .home:
            (ImageResource.tcHomeFill, ImageResource.tcHome)
        case .reservation:
            (ImageResource.tcCalendarFill, ImageResource.tcCalendar)
//        case .likedStudios:
//            (ImageResource.tcBookmarkFill, ImageResource.tcBookmarkGray)
        case .myPage:
            (ImageResource.tcProfileFill, ImageResource.tcProfile)
        }
    }
    
    var fontColor: (selected: Color, unselected: Color) {
        switch self {
        case .home, .reservation,/* .likedStudios, */ .myPage:
            (Color.tcGray10, Color.tcGray04)
        }
    }
}
