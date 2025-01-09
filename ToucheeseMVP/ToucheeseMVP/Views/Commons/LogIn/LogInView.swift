//
//  LogInView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/22/24.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
    @EnvironmentObject private var studioLikeListViewModel: StudioLikeListViewModel
    @EnvironmentObject private var reservationListViewModel: ReservationListViewModel
    
    private let viewModel: LogInViewModel = LogInViewModel()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Image(.tcLogInLogo)
                    .padding(.bottom, 20)
                
                Text("나에게 딱 맞는 스튜디오를\n한 눈에 살펴보세요.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundStyle(.tcGray10)
                    .font(.pretendardBold(24))
                    .padding(.bottom, 10)
                
                Text("컨셉별 스튜디오를 확인 후 예약까지 간편하게!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.tcGray06)
                    .font(.pretendardRegular16)
                    .padding(.bottom, 30)
                
                VStack(spacing: 8) {
                    Button {
                        Task {
                            await viewModel.loginWithKakaotalk()
                            await viewModel.handleAuthorizationWithKakao {
                                await studioLikeListViewModel.fetchLikedStudios()
                                await reservationListViewModel.fetchReservations()
                                await reservationListViewModel.fetchPastReservations()
                            }
                            
                            isPresented.toggle()
                        }
                    } label: {
                        Image(.kakaoLoginButton)
                            .resizable()
                            .frame(width: 360, height: 48)
                    }
                    
                    
                    SignInWithAppleButton { request in
                        request.requestedScopes = []
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Apple Authorization successful.")
                            Task {
                                await viewModel.handleAuthorizationWithApple(authResults) {
                                    await studioLikeListViewModel.fetchLikedStudios()
                                    await reservationListViewModel.fetchReservations()
                                    await reservationListViewModel.fetchPastReservations()
                                    
                                    isPresented.toggle()
                                }
                            }
                        case .failure(let error):
                            print("Apple Authorization failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 360, height: 48)
                }
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(.tcXmark)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcGray10)
                        .padding(10)
                }
                .padding(.leading, 10)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tcPrimary01.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LogInView(isPresented: .constant(true))
}
