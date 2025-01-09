//
//  TrailingTextView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/13/24.
//

import SwiftUI

struct LeadingTextView: View {
    let text: String
    let font: Font?
    let textColor: Color?
    
    init(text: String, font: Font? = nil, textColor: Color? = nil) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(font ?? .pretendardSemiBold18)
                .foregroundStyle(textColor ?? .tcGray10)

            Spacer()
        }
    }
}

#Preview {
    LeadingTextView(text: "예약 정보")
}
