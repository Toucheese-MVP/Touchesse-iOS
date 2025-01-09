//
//  ReservationInfoView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/13/24.
//

import SwiftUI

struct ReservationInfoView: View {
    let studioName: String
    let studioAddress: String
    let reservationStatus: ReservationStatus
    let userName: String
    let reservationDateString: String
    let reservationTimeString: String
    
    var body: some View {
            VStack {
                VStack {
                    LeadingTextView(text: "예약 정보")
                        .padding(.bottom, 15)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.tcGray03, lineWidth: 1)
                        .background(.white)
                        .frame(height: 220)
                        .overlay {
                            VStack {
                                HStack {
                                    Text(studioName)
                                        .font(.pretendardSemiBold16)
                                        .foregroundStyle(.tcGray09)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 8)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundStyle(.tcGray01)
                                    .frame(height: 36)
                                    .overlay {
                                        HStack {
                                            Image(.tcLocationPin)
                                                .frame(width: 16, height: 16)
                                            
                                            Text(studioAddress)
                                                .font(.pretendardMedium13)
                                                .foregroundStyle(.tcGray06)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                
                                DividerView(color: .tcGray02)
                                    .padding(.vertical, 4)
                                
                                VStack(spacing: 8) {
                                    horizontalPaddingTextView(leadingText: "예약자 성함", trailingText: userName)
                                    
                                    horizontalPaddingTextView(leadingText: "예약 날짜", trailingText: reservationDateString)
                                    
                                    horizontalPaddingTextView(leadingText: "예약 시간", trailingText: reservationTimeString)
                                }
                                .padding(.vertical, 8)
                            }
                            .padding(16)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            .frame(width: .screenWidth, height: 287)
    }
    
    private func horizontalPaddingTextView(leadingText: String, trailingText: String) -> some View {
        HStack {
            Text(leadingText)
                .font(.pretendardRegular14)
                .foregroundStyle(.tcGray06)
            
            Spacer()
            
            Text(trailingText)
                .font(.pretendardSemiBold14)
                .foregroundStyle(.tcGray09)
        }
    }
}

#Preview {
    ReservationInfoView(
        studioName: "유프스튜디오",
        studioAddress: "서울 성동구 아차산로 97",
        reservationStatus: .waiting,
        userName: "김마루",
        reservationDateString: "2024년 12월 13일",
        reservationTimeString: "오후 01:00"
    )
}
