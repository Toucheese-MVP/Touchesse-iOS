//
//  ReservationStatusView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI

struct ReservationStatusView: View {
    let status: ReservationStatus
    
    init(_ status: ReservationStatus) {
        self.status = status
    }
    
    var body: some View {
        Text(status.title)
            .font(.pretendardMedium(11))
            .foregroundStyle(status.color.font)
            .padding(.vertical, 5)
            .padding(.horizontal, 6)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(status.color.background)
                    
            }
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(status.color.stroke, lineWidth: 0.92)
            }
    }
}

#Preview {
    VStack(spacing: 10) {
        ReservationStatusView(.waiting)
        ReservationStatusView(.confirm)
        ReservationStatusView(.complete)
        ReservationStatusView(.cancel)
    }
}
