//
//  ReservationCompleteView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/9/24.
//

import SwiftUI

struct ReservationCompleteView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var isShowingSettingAlert: Bool = false
    
    var body: some View {
        let confirmMessage = "예약 신청이 완료되었습니다!"
        let description = "스튜디오와 최종 확인 후 예약이\n확정되거나 취소되면 알림을 받을 수 있습니다."
        let attributeTarget = "확정되거나 취소"
        
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    Image(.tcConfirm)
                        .frame(width: 80, height: 80)
                        .padding(.bottom, 32)
                    
                    Text(confirmMessage)
                        .font(.pretendardSemiBold24)
                        .foregroundStyle(.black)
                        .padding(.bottom, 16)
                    
                    Text(attributedString(string: description, targetString: attributeTarget))
                        .font(.pretendardMedium18)
                        .foregroundStyle(.tcGray06)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .screenWidth)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.tcGray01)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .padding(.bottom, 99)
                
                VStack {
                    Button {
                        navigationManager.goFirstViewAndSecondTap()
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.tcPrimary06)
                            .overlay {
                                HStack {
                                    Text("예약 일정 확인하러 가기")
                                        .font(.pretendardSemiBold18)
                                        .padding(.trailing, 8)
                                    
                                    Image(.tcRightChevron)
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .foregroundStyle(.tcGray10)
                        
                    }
                    .frame(height: 52)
                    .padding(.bottom, 8)
                    
                    Button {
                        navigationManager.goFirstView()
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.tcPrimary07, lineWidth: 1)
                            .overlay {
                                Text("확인")
                                    .font(.pretendardSemiBold18)
                                    .foregroundStyle(.tcPrimary07)
                            }
                            .foregroundStyle(.tcGray10)
                        
                    }
                    .frame(height: 52)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 55.5)
                
                Spacer()
            }
            
            if isShowingSettingAlert {
                CustomAlertView(
                    isPresented: $isShowingSettingAlert,
                    alertType: .notificationSetting
                ) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                print("😀\(settings.authorizationStatus)")
                if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                    isShowingSettingAlert = true
                }
            }
        }
    }
    
    private func attributedString(string: String, targetString: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        if let range = attributedString.range(of: targetString) {
            attributedString[range].font = .pretendardBold18
            attributedString[range].foregroundColor = .tcPrimary07
        }
        
        return attributedString
    }
}

#Preview {
    NavigationStack {
        ReservationCompleteView()
            .environmentObject(NavigationManager())
    }
}
