//
//  TempMyPageView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/10/25.
//

import SwiftUI

struct MyPageView<ViewModel: MyPageViewModelProtocol>: View {
    @ObservedObject var myPageViewModel: ViewModel
    @ObservedObject private var authenticationManager = AuthenticationManager.shared
    
    @State private var isLogin = true
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isShowingWithdrawalAlert: Bool = false
    @State private var isShowingLoginView: Bool = false
    @State private var isShowingSettingAlert: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if authenticationManager.authStatus == .authenticated {
                        GreetingView()
                    } else if authenticationManager.authStatus == .notAuthenticated{
                        LoginButtonView(isShowingLoginView: $isShowingLoginView)
                    }
                    
                    DividerView(color: .tcGray01, height: 9)
                    
                    InfoView(
                        viewModel: myPageViewModel,
                        isShowingSettingAlert: $isShowingSettingAlert
                    )
                    
                    if authenticationManager.authStatus == .authenticated {
                        DividerView(color: .tcGray01, height: 9)
                        
                        LoginChangeView(
                            isShowingLogoutAlert: $isShowingLogoutAlert,
                            isShowingWithdrawalAlert: $isShowingWithdrawalAlert
                        )
                    }
                }
            }
            .customNavigationBar {
                Text("내 정보")
                    .font(.pretendardBold(20))
                    .foregroundStyle(.tcGray10)
            }
            
            if isShowingLogoutAlert {
                CustomAlertView(
                    isPresented: $isShowingLogoutAlert,
                    alertType: .logout) {
                       
                        Task {
                            await myPageViewModel.logout()
                        }
                }
            }
            
            if isShowingWithdrawalAlert {
                CustomAlertView(
                    isPresented: $isShowingWithdrawalAlert,
                    alertType: .withdrawal) {
                        Task {
                            await myPageViewModel.withdrawl()
                        }
                }
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
        .fullScreenCover(isPresented: $isShowingLoginView, content: {
            LoginView(TviewModel: LogInViewModel(),
                          isPresented: $isShowingLoginView)
        })
        .onAppear {
            myPageViewModel.calImageCacheUse()
        }
    }
    
    struct InfoView: View {
        @EnvironmentObject private var navigationManager: NavigationManager
        @ObservedObject var viewModel: ViewModel
        @Binding var isShowingSettingAlert: Bool
        
        var body: some View {
            VStack(spacing: 0) {
                MyPageHorizontalView(
                    leftText: "약관 및 정책",
                    rightView: Image(.tcBoldRightChevron)
                        .frame(width: 24, height: 24),
                    action: {
                        viewModel.openPolicyWebView()
                    }
                )
                
                MyPageHorizontalView(
                    leftText: "오픈소스 라이선스",
                    rightView: Image(.tcBoldRightChevron)
                        .frame(width: 24, height: 24),
                    action: {
                        viewModel.openLicenseWebView()
                    }
                )
                
                MyPageHorizontalView(
                    leftText: "알림 설정",
                    rightView: EmptyView(),
                    action: {
                        isShowingSettingAlert = true
                        navigationManager.isShowingAlert = true
                    }
                )
                
                MyPageHorizontalView(
                    leftText: "캐시 데이터 삭제하기",
                    rightView: Text(viewModel.imageCacheUse)
                        .font(.pretendardRegular(16))
                        .foregroundStyle(.tcGray06),
                    action: {
                        viewModel.clearImageCache()
                    }
                )
                
                VStack(spacing: 0) {
                    HStack {
                        Text("앱 버전")
                            .font(.pretendardSemiBold(16))
                            .foregroundStyle(.tcGray09)
                        
                        Spacer()
                        
                        Text(viewModel.appVersionString)
                            .font(.pretendardRegular(16))
                            .foregroundStyle(.tcGray06)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(width: .screenWidth, height: 65)
                    
                    DividerView(color: .tcGray02)
                }
                
                MyPageHorizontalView(
                    leftText: "문의 메일",
                    rightView: Text(viewModel.contactEmailString),
                    action: {
                        // myPageViewModel.copyContactEmail()
                    }
                )
            }
        }
    }
}

fileprivate struct GreetingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @ObservedObject private var authenticationManager = AuthenticationManager.shared
    
    var body: some View {
        let nickName = authenticationManager.memberNickname ?? ""
        
        VStack(spacing: 0) {
            LeadingTextView(text: "\(nickName)님, 반가워요!", font: .pretendardSemiBold(20), textColor: .tcGray10)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
        }
        .padding(.top, 8)
    }
}

fileprivate struct LoginButtonView: View {
    @Binding var isShowingLoginView: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                isShowingLoginView.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.tcPrimary06)
                    .frame(height: 48)
                    .overlay {
                        Text("로그인 하기")
                            .font(.pretendardSemiBold(18))
                            .foregroundStyle(.tcGray10)
                            .padding(.trailing, 8)
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 55.5)
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
        
        DividerView(color: .tcGray02)
    }
}

fileprivate struct LoginChangeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Binding var isShowingLogoutAlert: Bool
    @Binding var isShowingWithdrawalAlert: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            MyPageHorizontalView(
                leftText: "로그아웃",
                rightView: EmptyView(),
                action: {
                    isShowingLogoutAlert.toggle()
                    navigationManager.isShowingAlert = true
                }
            )
            
            MyPageHorizontalView(
                leftText: "회원 탈퇴",
                rightView: EmptyView(),
                action: {
                    isShowingWithdrawalAlert.toggle()
                    navigationManager.isShowingAlert = true
                }
            )
        }
    }
}

fileprivate struct MyPageHorizontalView<RightView: View>: View {
    var leftText: String
    var rightView: RightView
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 0) {
                HStack {
                    Text(leftText)
                        .font(.pretendardSemiBold(16))
                        .foregroundStyle(.tcGray09)
                    
                    Spacer()
                    
                    rightView
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(width: .screenWidth, height: 65)
                
                DividerView(color: .tcGray02)
            }
        }
        
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel(navigationManager: NavigationManager()))
}
