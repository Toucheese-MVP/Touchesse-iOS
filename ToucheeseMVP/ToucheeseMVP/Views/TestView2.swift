//
//  TestView2.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI
import AuthenticationServices

struct TestView2: View {
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Button {
                isShowingLogInView.toggle()
            } label: {
                Text("로그인 테스트")
            }
            
            Button {
                authManager.logout()
            } label: {
                Text("로그아웃 테스트")
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isShowingLogInView) {
            LoginView(TviewModel: LogInViewModel(),
                          isPresented: $isShowingLogInView)
        }
    }
}

#Preview {
    TestView2()
}
