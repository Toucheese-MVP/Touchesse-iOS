//
//  NavigationTitleModifier.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/13/24.
//

import SwiftUI

struct NavigationTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardBold20)
            .frame(height: 56)
    }
}
