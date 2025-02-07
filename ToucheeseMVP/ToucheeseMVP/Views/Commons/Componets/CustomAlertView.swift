//
//  CustomAlertView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/14/24.
//

import SwiftUI

enum AlertType {
    case reservationCancel
    case reservationCancelComplete
    case login
    case logout
    case withdrawal
    
    var title: String {
        switch self {
        case .login: "로그인 후 이용 가능합니다."
        default: ""
        }
    }
    
    var description: String {
        switch self {
        case .reservationCancel: "정말 예약을 취소하시겠습니까?"
        case .reservationCancelComplete: "예약이 취소되었습니다."
        case .login: "로그인 하시겠습니까?"
        case .logout: "정말 로그아웃 하시겠습니까?"
        case .withdrawal: "정말 회원탈퇴 하시겠습니까?"
        }
    }
}

struct CustomAlertView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Binding var isPresented: Bool
    let alertType: AlertType
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.tcGray09
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !alertType.title.isEmpty {
                    Text(alertType.title)
                        .foregroundStyle(.tcGray09)
                        .font(.pretendardSemiBold18)
                        .padding(.bottom, 6)
                }
                
                Text(alertType.description)
                    .foregroundStyle(.tcGray09)
                    .font(.pretendardMedium16)
                    .padding(.bottom, 24)
                
                switch alertType {
                    // 버튼의 액션이 필요한 경우
                case .reservationCancel, .login, .logout, .withdrawal:
                    HStack(spacing: 12) {
                        FillBottomButton(
                            isSelectable: true,
                            title: "확인",
                            height: 48
                        ) {
                            isPresented.toggle()
                            navigationManager.isShowingAlert = false
                            
                            action()
                        }
                        
                        FillBottomButton(
                            isSelectable: true,
                            title: "취소",
                            height: 48,
                            backgroundColor: .tcGray02
                        ) {
                            isPresented.toggle()
                            navigationManager.isShowingAlert = false
                        }
                    }
                    // Alert Dismiss만 필요한 경우
                case .reservationCancelComplete:
                    FillBottomButton(
                        isSelectable: true,
                        title: "확인",
                        height: 48
                    ) {
                        isPresented.toggle()
                        navigationManager.isShowingAlert = false
                        
                        action()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
            .padding(.horizontal, 44)
        }
    }
}

#Preview {
    ScrollView(.vertical) {
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .reservationCancel
        ) {
            print("액션")
        }
        
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .reservationCancelComplete
        ) {
            print("액션")
        }
        
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .logout
        ) {
            print("액션")
        }
        
        CustomAlertView(
            isPresented: .constant(true),
            alertType: .withdrawal
        ) {
            print("액션")
        }
    }
}
