//
//  StrokeButton.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/14/24.
//

import SwiftUI

struct StrokeBottomButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.pretendardSemiBold18)
                .foregroundStyle(.tcPrimary07)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tcPrimary07, lineWidth: 1)
        }
    }
}

#Preview {
    StrokeBottomButton(title: "예약 취소하기") {
        print("액션")
    }
}
