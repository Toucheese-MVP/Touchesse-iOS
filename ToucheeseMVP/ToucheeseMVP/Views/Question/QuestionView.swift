//
//  QuestionView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/17/25.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct QuestionView<ViewModel: QuestionViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        VStack {
            // 로그아웃 상태 -> 로그인 안내
            if authManager.authStatus == .notAuthenticated {
                CustomEmptyView(viewType: .requiredLogIn(buttonText: "로그인 하기", buttonAction: {
                    isShowingLogInView.toggle()
                }))
            // 문의 내역이 없을 경우 -> 문의 생성 안내
            } else if viewModel.questions.isEmpty {
                CustomEmptyView(viewType: .question(buttonText: "문의 작성하기", buttonAction: {
                    navigationManager.appendPath(viewType: .questionCreateView, viewMaterial: nil)
                }))
                .padding(.horizontal, 36)
            } else {
                ZStack {
                    // 문의 내역 스크롤 뷰
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                            .frame(height: 12)
                        
                        VStack(spacing: 0) {
                            ForEach(viewModel.questions, id: \.self) { question in
                                Button {
                                    navigationManager.appendPath(viewType: .qustionDetailView(qustion: question),
                                                                 viewMaterial: nil)
                                } label: {
                                    QuestionCardView(question: question, isShowingContent: false)
                                }
                                .onAppear {
                                    if question == viewModel.questions.last {
                                        Task {
                                            await viewModel.fetchQuestions()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: .screenWidth)
                    .background(Color.tcGray01)
                    .refreshable {
                        Task {
                            await viewModel.refreshAction()
                        }
                    }
                    
                    // 문의 생성 버튼
                    CreateQuestionButton()
                }
                .task {
                    await viewModel.fetchQuestions()
                }
            }
        }
        .customNavigationBar {
            Text("문의하기")
                .font(.pretendardBold(20))
                .foregroundStyle(.tcGray10)
        }
        .fullScreenCover(isPresented: $isShowingLogInView) {
            LoginView(TviewModel: LogInViewModel(),
                      isPresented: $isShowingLogInView)
        }
        .onChange(of: isShowingLogInView) { _ in
            Task {
                await viewModel.fetchQuestions()
            }
        }
    }
}

fileprivate struct CreateQuestionButton: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    navigationManager.appendPath(viewType: .questionCreateView, viewMaterial: nil)
                } label: {
                    HStack(spacing: 0) {
                        Image(.tcAdd)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(Color.tcGray10)
                            .padding(.trailing, 4)
                        
                        Text("문의 작성하기")
                            .font(.pretendardSemiBold(16))
                            .foregroundStyle(Color.tcGray10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.tcPrimary05)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    QuestionView(viewModel: QuestionViewModel())
        .environmentObject(NavigationManager())
}
