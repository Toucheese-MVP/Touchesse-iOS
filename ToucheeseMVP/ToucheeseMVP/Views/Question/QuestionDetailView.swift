//
//  QuestionDetailView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/25/25.
//

import SwiftUI

struct QuestionDetailView<ViewModel: QuestionDetailViewModelProtocol>: View {
    @EnvironmentObject private var navigationManger: NavigationManager
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer()
                .frame(height: 12)
            
            VStack(spacing: 0) {
                // 문의 내역 뷰
                QuestionCardView(question: viewModel.question, isShowingContent: true)
                    .padding(.bottom, 12)
                
                // 답변이 있을 경우 답변 뷰
                if let response = viewModel.questionResponse {
                    QuestionResponseView(questionResponse: response)
                }
            }
        }
        .frame(width: .screenWidth)
        .background(Color.tcGray01)
        .customNavigationBar {
            Text("문의 상세확인")
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
    
    struct QuestionResponseView: View {
        let questionResponse: QuestionResponse
        
        var body: some View {
            VStack(spacing: 0) {
                VStack {
                    LeadingTextView(text: questionResponse.title,
                                    font: Font.pretendardSemiBold(16),
                                    textColor: Color.tcGray10)
                    .padding(.bottom, 12)
                    
                    LeadingTextView(text: questionResponse.content,
                                    font: Font.pretendardRegular(14),
                                    textColor: Color.tcGray10)
                    .padding(.bottom, 12)
                    
                    HStack {
                        Text("터치즈 담당자")
                            .font(.pretendardMedium(12))
                            .foregroundStyle(Color.tcGray09)
                        
                        Text("| 작성일: \(questionResponse.createDate.toDate(dateFormat: .YYMMDD)!.toString(format: .YYMMDD))")
                            .font(.pretendardRegular(12))
                            .foregroundStyle(Color.tcGray05)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.tcGray02, lineWidth: 1)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.tcPrimary01)
                        }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

#Preview {
    QuestionDetailView(viewModel: QuestionDetailViewModel(question: Question.sample1))
        .environmentObject(NavigationManager())
}
