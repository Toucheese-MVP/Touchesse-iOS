//
//  StudioLikeListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/26/24.
//

import SwiftUI

struct StudioLikeListView: View {
    @EnvironmentObject private var viewModel: StudioLikeListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @State private var isShowingLoginAlert = false
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        VStack {
            if authManager.authStatus == .notAuthenticated {
                CustomEmptyView(viewType: .requiredLogIn(buttonText: "로그인 하기") {
                    isShowingLogInView.toggle()
                })
            } else {
                if viewModel.likedStudios.isEmpty {
                    CustomEmptyView(viewType: .studioLike)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        Color.clear
                            .frame(height: 11)
                        
                        LazyVStack(spacing: 20) {
                            HStack(spacing: 0) {
                                Text("총")
                                    .padding(.trailing, 3)
                                
                                Text("\(viewModel.likedStudios.count)")
                                    .foregroundStyle(.tcPrimary06)
                                    .font(.pretendardMedium14)
                                
                                Text("개의 스튜디오가 있습니다.")
                                
                                Spacer()
                            }
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardRegular14)
                            .padding(.horizontal, 16)
                            
//                            ForEach(viewModel.likedStudios) { studio in
//                                StudioRow(
//                                    studio: studio,
//                                    isShowingLoginAlert: $isShowingLoginAlert
//                                )
//                                .contentShape(.rect)
//                                .onTapGesture {
//                                    navigationManager.appendPath(
//                                        viewType: .studioDetailView,
//                                        viewMaterial: StudioDetailViewMaterial(viewModel: StudioDetailViewModel(studio: studio))
//                                    )
//                                }
//                            }
                        }
                        
                        Color.clear
                            .frame(height: 25)
                    }
                    .refreshable {
                        Task {
                            await viewModel.fetchLikedStudios()
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingLogInView) {
            LoginView(TviewModel: LogInViewModel(),
                          isPresented: $isShowingLogInView)
        }
        .customNavigationBar {
            Text("찜 목록")
                .modifier(NavigationTitleModifier())
        }
        .onChange(of: isShowingLogInView) { _ in
            Task {
                await viewModel.fetchLikedStudios()
            }
        }
    }
}

#Preview {
    StudioLikeListView()
        .environmentObject(StudioLikeListViewModel())
        .environmentObject(NavigationManager())
}
