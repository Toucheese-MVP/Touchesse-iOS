//
//  QuestionCreateView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/26/25.
//

import SwiftUI
import PhotosUI

struct QuestionCreateView<ViewModel: QuestionCreateViewModelProtocol, ImageViewModel: ImageUploadViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var imageViewModel: ImageViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    let viewHorizontalPadding: CGFloat = 16
    
    // 문의 등록이 가능한 상태값
    private var selectable: Bool {
        viewModel.questionTitle.isEmpty || viewModel.questionContent.isEmpty || imageViewModel.isLoadingImage ? false : true
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        LeadingTextView(text: "제목",
                                        font: Font.pretendardMedium14,
                                        textColor: Color.tcGray06)
                        .padding(.top, 16)
                        
                        // 문의 제목 텍스트 필드
                        TextFieldView(inputValue: $viewModel.questionTitle,
                                      placeHolder: "제목을 입력해주세요",
                                      width: CGFloat.screenWidth - (viewHorizontalPadding * 2),
                                      height: 56,
                                      showClearButton: false)
                        .padding(.top, 4)
                        
                        LeadingTextView(text: "문의 내용 작성",
                                        font: Font.pretendardMedium14,
                                        textColor: Color.tcGray06)
                        .padding(.top, 27)
                        
                        // 문의 내용 텍스트 필드
                        MultiLineTextFieldView(inputValue: $viewModel.questionContent,
                                               placeHolder: "문의내용을 입력해주세요",
                                               width: CGFloat.screenWidth - (viewHorizontalPadding * 2))
                        .padding(.top, 4)
                        
                        // 이미지 선택 뷰
                        ImageSelectView(imageViewModel: imageViewModel)
                            .padding(.top, 27)
                        
                        // 문의 등록 버튼
                        FillBottomButton(isSelectable: selectable, title: "문의 등록") {
                            Task {
                                let imageDatas = await imageViewModel.getDownSizedImageData()
                                await viewModel.postQuestion(imageDatas)
                                navigationManager.pop(1)
                            }
                        }
                        .padding(.top, 44)
                        .padding(.bottom, 62.5)
                    }
                }
                .padding(.horizontal, viewHorizontalPadding)
                .frame(width: .screenWidth)
                .background(Color.tcGray01)
            }
            
            if viewModel.isPostingQuestion {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundStyle(Color.black.opacity(0.1))
                    
                    ProgressView()
                }
            }
        }
        .onAppear{ UIApplication.shared.hideKeyboard() }
        .customNavigationBar {
            Text("문의하기")
                .font(.pretendardBold(20))
                .foregroundStyle(.tcGray10)
        } leftView: {
            Button {
                navigationManager.pop(1)
            } label: {
                NavigationBackButtonView()
            }
        }
    }
}

#Preview {
    QuestionCreateView(viewModel: QuestionCreateViewModel(), imageViewModel: ImageUploadViewModel())
}
