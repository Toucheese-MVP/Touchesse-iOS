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
    case question
    case myPage
}

extension Tab {
    var title: String {
        switch self {
        case .home: return "홈"
        case .reservation: return "예약일정"
        case .question: return "문의하기"
        case .myPage: return "내정보"

        }
    }
    
    var iconImage: (selected: ImageResource, unselected: ImageResource) {
        switch self {
        case .home:
            (ImageResource.tcHomeFill, ImageResource.tcHome)
        case .reservation:
            (ImageResource.tcCalendarFill, ImageResource.tcCalendar)
        case .question:
            (ImageResource.tcProfileFill, ImageResource.tcProfile)
        case .myPage:
            (ImageResource.tcProfileFill, ImageResource.tcProfile)
        }
    }
    
    var fontColor: (selected: Color, unselected: Color) {
        switch self {
        case .home, .reservation, .question, .myPage:
            (Color.tcGray10, Color.tcGray04)
        }
    }
}
