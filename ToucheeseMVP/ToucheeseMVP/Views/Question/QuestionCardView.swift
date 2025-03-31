//
//  QuestionCardView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/25/25.
//

import SwiftUI
import Kingfisher

struct QuestionCardView: View {
    let question: Question
    let isShowingContent: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Q.")
                    .font(.pretendardBold(16))
                    .foregroundStyle(Color.tcPrimary06)
                    .padding(.trailing, 4)
                
                Text(question.title)
                    .font(.pretendardSemiBold(16))
                    .foregroundStyle(Color.tcGray10)
                
                Spacer()
                
                QuestionStatusBadgeView(questionStats: question.questionStaus)
            }
            .padding(.bottom, 12)
            
            if isShowingContent {
                LeadingTextView(text: question.content,
                                font: .pretendardRegular(14),
                                textColor: Color.tcGray10)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(question.imageUrls, id: \.self) { urlString in
                        if let imageURL = URL(string: urlString) {
                            KFImage(imageURL)
                                .placeholder { ProgressView() }
                                .resizable()
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    
                    Spacer()
                }
            }
            
            HStack {
                Text(question.authorName)
                    .font(.pretendardMedium(12))
                    .foregroundStyle(Color.tcGray09)
                
                Text("| 작성일: \(question.createDate.toDate(dateFormat: .YYMMDD)!.toString(format: .YYMMDD))")
                    .font(.pretendardRegular(12))
                    .foregroundStyle(Color.tcGray05)
                
                Spacer()
            }
        }
        .frame(maxWidth: .screenWidth)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 1)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

fileprivate struct QuestionStatusBadgeView: View {
    let questionStats: QuestionStatus
    
    var body: some View {
        VStack {
            Text(questionStats.title)
                .font(.pretendardSemiBold(11))
                .foregroundStyle(questionStats == .complete ? .tcPrimary06 : .tcGray05)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(questionStats == .complete ? .tcPrimary01 : .tcGray01)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(questionStats == .complete ? .tcPrimary06 : .tcGray03, lineWidth: 1)
                        }
                }
        }
    }
}

#Preview {
    QuestionCardView(question: Question.sample1, isShowingContent: true)
}
