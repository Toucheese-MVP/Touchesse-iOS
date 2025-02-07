//
//  CustomNavigationBarModifier.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI

struct CustomNavigationBarModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
    let centerView: (() -> C)?
    let leftView: (() -> L)?
    let rightView: (() -> R)?
    
    init(
        centerView: (() -> C)? = nil,
        leftView: (() -> L)? = nil,
        rightView:(() -> R)? = nil
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    leftView?()
                    
                    Spacer()
                    
                    rightView?()
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    
                    centerView?()
                    
                    Spacer()
                }
            }
            
            content
            
            // CustomNavigationBarModifier 사용 시 레이아웃이 이상해질 경우, 아래 Spacer 주석 풀어보기
            // Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
