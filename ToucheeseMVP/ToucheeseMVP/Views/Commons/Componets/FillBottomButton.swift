//
//  BottomButtonView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/14/24.
//

import SwiftUI

struct FillBottomButton: View {
    var isSelectable: Bool
    let title: String
    let height: CGFloat
    let backgroundColor: Color
    let action: () -> Void
    
    init(
        isSelectable: Bool,
        title: String,
        height: CGFloat = 48,
        backgroundColor: Color = .tcPrimary06,
        action: @escaping () -> Void
    ) {
        self.isSelectable = isSelectable
        self.title = title
        self.height = height
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(
                        isSelectable ? backgroundColor == .tcGray02 ? .tcGray02 : .tcPrimary06 : .tcGray03
                    )
                    .frame(height: height)
                    .overlay {
                        Text(title)
                            .font(.pretendardSemiBold18)
                            .foregroundStyle(isSelectable ? .tcGray10 : .tcGray05)
                    }
                
            }
            .disabled(!isSelectable)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FillBottomButton(isSelectable: true, title: "예약하기") { }
        
        FillBottomButton(isSelectable: false, title: "예약하기") { }
        
        // Alert Version
        HStack(spacing: 10) {
            FillBottomButton(isSelectable: true, title: "확인", height: 48) { }
            FillBottomButton(isSelectable: true, title: "취소", height: 48, backgroundColor: .tcGray02) { }
        }
        .padding(.horizontal)
    }
}
