//
//  QuestionCreateView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/26/25.
//

import SwiftUI
import PhotosUI

struct QuestionCreateView<ViewModel: QuestionCreateViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject private var navigationManger: NavigationManager
    
    let viewHorizontalPadding: CGFloat = 16
    
    // 문의 등록이 가능한 상태값
    private var selectable: Bool {
        viewModel.questionTitle.isEmpty || viewModel.questionContent.isEmpty || viewModel.isLoadingImage ? false : true
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
                        ImageSelectView(viewModel: viewModel)
                            .padding(.top, 27)
                        
                        // 문의 등록 버튼
                        FillBottomButton(isSelectable: selectable, title: "문의 등록") {
                            Task {
                                await viewModel.postQuestion()
                                navigationManger.pop(1)
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
                navigationManger.pop(1)
            } label: {
                NavigationBackButtonView()
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    struct ImageSelectView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            if viewModel.isLoadingImage {
                ProgressView()
                    .frame(width: 84, height: 84)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.displaySelectedUIImageContents, id: \.originalIndex) { content in
                            ZStack {
                                Image(uiImage: content.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 84, height: 84)
                                    .clipShape(.rect(cornerRadius: 12))
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Button {
                                            Task {
                                                await viewModel.deleteSelectedImage(originalIndex: content.originalIndex)
                                            }
                                        } label: {
                                            Image("TCDelete.fill")
                                        }
                                    }
                                    .padding(.trailing, 6)
                                    
                                    Spacer()
                                }
                                .padding(.top, 6)
                            }
                            .frame(width: 84, height: 84)
                        }
                        
                        if viewModel.selectedPhotosPickerItems.count < 5 {
                            PhotosPicker(selection: $viewModel.selectedPhotosPickerItems,
                                         maxSelectionCount: 5,
                                         selectionBehavior: .ordered,
                                         matching: .images) {
                                RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color.tcGray04,
                                                  style: StrokeStyle(lineWidth: 1,
                                                                     dash: [3]))
                                    .frame(width: 84, height: 84)
                                    .overlay {
                                        VStack {
                                            Image(.tcCamera)
                                            Text("\(viewModel.selectedPhotosPickerItems.count)/5")
                                                .font(Font.pretendardMedium(14))
                                                .foregroundStyle(Color.tcGray05)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct MultiLineTextFieldView: View {
    @Binding var inputValue: String
    let placeHolder: String
    var isError: Bool = false
    var keyboardType: UIKeyboardType = .default
    var submitAction: () -> Void = { }
    
    var lineLimit = 10
    var width: CGFloat = 253
    var height: CGFloat = 20.4
    
    var body: some View {
        VStack(spacing: 0) {
            TextField(placeHolder, text: $inputValue, axis: .vertical)
                .font(Font.pretendardMedium(14))
                .foregroundStyle(.tcGray08)
                .lineLimit(lineLimit, reservesSpace: true)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(keyboardType)
                .onSubmit {
                    submitAction()
                }
                .frame(height: height * CGFloat(lineLimit))
                .padding(.leading, 16.5)
                .padding(.trailing, 4)
                .padding(.vertical, 6)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(inputValue.isEmpty ? .tcGray04 : isError ?  .tcTempError : .tcGray07, lineWidth: 1)
                }
        }
    }
}

#Preview {
    QuestionCreateView(viewModel: QuestionCreateViewModel())
}
