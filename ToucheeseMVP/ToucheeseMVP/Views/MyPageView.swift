//
//  MyPageView.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @ObservedObject private var authenticationManager = AuthenticationManager.shared
    
    @State private var isNicknameEditing: Bool = false
    @State private var isLogin = true
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isShowingWithdrawalAlert: Bool = false
    @State private var isShowingLoginView: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if authenticationManager.authStatus == .authenticated {
                        GreetingView(isNicknameEditing: $isNicknameEditing)
                    } else if authenticationManager.authStatus == .notAuthenticated{
                        LoginView(isShowingLoginView: $isShowingLoginView)
                    }
                    
                    DividerView(color: .tcGray01, height: 9)
                    
                    InfoView()
                    
                    
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
            
            if isNicknameEditing {
                NickNameEditView(
                    isNicknameEditing: $isNicknameEditing
                )
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
                            await myPageViewModel.withdrawal()
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingLoginView, content: {
            LogInView(isPresented: $isShowingLoginView)
        })
        .onAppear {
            myPageViewModel.calImageCacheUse()
        }
    }
}

fileprivate struct GreetingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Binding var isNicknameEditing: Bool
    @ObservedObject private var authenticationManager = AuthenticationManager.shared
    
    var body: some View {
        let nickName = authenticationManager.memberNickname ?? ""
        
        VStack(spacing: 0) {
            LeadingTextView(text: "\(nickName)님, 반가워요!", font: .pretendardSemiBold(20), textColor: .tcGray10)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            
            MyPageHorizontalView(
                leftText: "닉네임 수정하기",
                rightView: Image(.tcBoldRightChevron)
                    .frame(width: 24, height: 24),
                action: {
                    isNicknameEditing.toggle()
                    navigationManager.isShowingNicknameView = true
                }
            )
        }
        .padding(.top, 8)
    }
}

fileprivate struct LoginView: View {
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

fileprivate struct InfoView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    
    var body: some View {
        let imageCacheUse = myPageViewModel.imageCacheUse
        let appVersionString = myPageViewModel.appVersionString
        let contactEmailString = myPageViewModel.contactEmailString
        
        VStack(spacing: 0) {
            MyPageHorizontalView(
                leftText: "약관 및 정책",
                rightView: Image(.tcBoldRightChevron)
                    .frame(width: 24, height: 24),
                action: {
                    myPageViewModel.openPolicyWebView()
                }
            )
            
            MyPageHorizontalView(
                leftText: "오픈소스 라이선스",
                rightView: Image(.tcBoldRightChevron)
                    .frame(width: 24, height: 24),
                action: {
                    myPageViewModel.openLicenseWebView()
                }
            )
            
            MyPageHorizontalView(
                leftText: "캐시 데이터 삭제하기",
                rightView: Text(imageCacheUse)
                    .font(.pretendardRegular(16))
                    .foregroundStyle(.tcGray06),
                action: {
                    myPageViewModel.clearImageCache()
                }
            )
            
            VStack(spacing: 0) {
                HStack {
                    Text("앱 버전")
                        .font(.pretendardSemiBold(16))
                        .foregroundStyle(.tcGray09)
                    
                    Spacer()
                    
                    Text(appVersionString)
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
                rightView: Text(contactEmailString),
                action: {
                    // myPageViewModel.copyContactEmail()
                }
            )
        }
    }
}

fileprivate struct LoginChangeView: View {
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
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

fileprivate struct NickNameEditView: View {
    enum FocusedField {
        case nickname
    }
    
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Binding var isNicknameEditing: Bool
    @State var newName: String = ""
    @State var isNewNameValid: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        Color.black.opacity(0.33)
            .ignoresSafeArea()
            .onTapGesture {
                isNicknameEditing = false
                navigationManager.isShowingNicknameView = false
            }
        
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.white)
            .frame(width: 361, height: 271)
            .overlay {
                VStack {
                    Text("닉네임 수정")
                        .font(.pretendardSemiBold(18))
                        .foregroundStyle(.tcGray09)
                        .padding(.bottom, 18)
                        .padding(.top, 32)
                    
                    LeadingTextView(text: "닉네임", font: .pretendardSemiBold(14), textColor: .tcGray08)
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.tcGray04, lineWidth: 1)
                            .frame(height: 48)
                            .padding(.trailing, 8)
                            .overlay {
                                HStack {
                                    TextField("", text: $newName)
                                        .font(.pretendardMedium(16))
                                        .foregroundStyle(.tcGray08)
                                        .lineLimit(1)
                                        .padding(.leading, 16)
                                        .padding(.trailing, newName.isEmpty ? 16 : 4)
                                        .padding(.vertical, 12)
                                        .focused($focusedField, equals: .nickname)

                                    
                                    if !newName.isEmpty {
                                        Spacer()
                                        
                                        Button {
                                            newName = ""
                                        } label: {
                                            Image(.tcDelete)
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(.tcGray04)
                                        }
                                        .padding(.trailing, 16)
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 8)
                    
                    LeadingTextView(text: "\(newName.count)/10글자", font: .pretendardMedium(14), textColor: .tcGray08)
                    
                    Spacer()
                    
                    Button {
                        isNicknameEditing.toggle()
                        navigationManager.isShowingNicknameView = false
                        
                        Task {
                            await myPageViewModel.changeNickname(newName: newName)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(isNewNameValid ? .tcPrimary06 : .tcGray03)
                            .overlay {
                                Text("수정하기")
                                    .font(.pretendardSemiBold(18))
                                    .foregroundStyle(isNewNameValid ? .tcGray10 : .tcGray05)
                            }
                    }
                    .disabled(!isNewNameValid)
                    .frame(height: 48)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
                focusedField = .nickname
            }
            .onChange(of: newName) { newValue in
                if newValue.count > 10 {
                    newName.removeLast()
                }
                
                calIsNewNameValid()
            }
    }
    
    private func calIsNewNameValid() {
        if newName.isEmpty {
            isNewNameValid = false
            return
        }
        
        if isContainSpecialChar() {
            isNewNameValid = false
            return
        }
        
        isNewNameValid = true
    }
    
    private func isContainSpecialChar() -> Bool {
        if newName.contains(/[^a-zA-Z0-9가-힣]/) {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageViewModel())
}
