//
//  ReservationStateButton.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/13/24.
//

import SwiftUI

struct ReservationStatusBadge: View {
    let reservationStatus: ReservationStatus
    
    var innerColor: Color {
        switch reservationStatus {
        case .waiting:
                .tcGray03
        case .confirm:
                .white
        case .complete:
                .tcPrimary05
        case .cancel:
                .white
        }
    }
    
    var strokeColor: Color {
        switch reservationStatus {
        case .waiting:
                .tcGray03
        case .confirm:
                .tcPrimary07
        case .complete:
                .tcPrimary05
        case .cancel:
                .tcTempError
        }
    }
    
    var textColor: Color {
        switch reservationStatus {
        case .waiting:
                .tcGray09
        case .confirm:
                .tcPrimary07
        case .complete:
                .tcGray09
        case .cancel:
                .tcTempError
        }
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(strokeColor, lineWidth: 1)
                .frame(width: 53, height: 24)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(innerColor)
                        .overlay {
                            Text(reservationStatus.description)
                                .font(.pretendardMedium11)
                                .foregroundStyle(textColor)
                        }
                }
        }
    }
}

#Preview {
    ReservationStatusBadge(reservationStatus: .cancel)
}
