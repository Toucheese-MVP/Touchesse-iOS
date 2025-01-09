//
//  ReservationRow.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationRow: View {
    let reservation: Reservation
    private var status: ReservationStatus {
        ReservationStatus(rawValue: reservation.reservationStatus)!
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangleProfileImageView(
                imageURL: reservation.studioProfileImageURL,
                size: 74,
                cornerRadius: 6,
                downsamplingSize: 150
            )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(reservation.studioName)
                        .font(.pretendardSemiBold16)
                        .foregroundStyle(.tcGray10)
                    
                    Spacer()
                    
                    ReservationStatusView(status)
                }
                
                Spacer()
                
                HStack {
                    Text("예약 날짜")
                        .font(.pretendardRegular14)
                        .foregroundStyle(.tcGray05)
                    
                    Spacer()
                    
                    Text(reservation.reservationDate.toReservationDateType)
                        .font(.pretendardMedium(13))
                        .foregroundStyle(.tcGray08)
                }
                
                HStack {
                    Text("예약 시간")
                        .font(.pretendardRegular14)
                        .foregroundStyle(.tcGray05)
                    
                    Spacer()
                    
                    Text(reservation.reservationTimeString)
                        .font(.pretendardMedium(13))
                        .foregroundStyle(.tcGray08)
                }
            }
            .frame(height: 74)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.tcGray03, lineWidth: 1)
                }
            
        }
        .frame(height: 106)
    }
}

#Preview {
    VStack(spacing: 8) {
        ReservationRow(reservation: Reservation.sample)
        ReservationRow(reservation: Reservation.sample)
        ReservationRow(reservation: Reservation.sample)
    }
    .padding()
}
