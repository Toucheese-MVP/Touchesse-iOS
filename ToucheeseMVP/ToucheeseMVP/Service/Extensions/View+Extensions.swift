//
//  View+Navigation.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI

// MARK: 커스텀 네비게이션 컨트롤러 사용을 위한 확장자
extension View {
    func customNavigationBar<C>(
        centerView: @escaping (() -> C)
    ) -> some View where C: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: {
                    EmptyView()
                },
                rightView: {
                    EmptyView()
                }
            )
        )
    }
    
    func customNavigationBar<C, L>(
        centerView: @escaping (() -> C),
        leftView: @escaping (() -> L)
    ) -> some View where C: View, L: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: {
                    EmptyView()
                }
            )
        )
    }
    
    func customNavigationBar<C, L, R>(
        centerView: @escaping (() -> C),
        leftView: @escaping (() -> L),
        rightView: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier (
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: rightView
            )
        )
    }
}
