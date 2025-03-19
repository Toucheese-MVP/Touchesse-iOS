//
//  QuestionView.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/17/25.
//

import SwiftUI
import PhotosUI

struct QuestionView<ViewModel: QuestionViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Button {
                Task {
                    await viewModel.postQuestion()
                }
            } label: {
                Text("이미지랑 문의 글 올리기~~")
            }
            
            Button {
                Task {
                    await viewModel.fetchQuestions()
                }
            } label: {
                Text("문의목록 가져오기~~")
            }
            
            ScrollView {
                ForEach(viewModel.displaySelectedUIImages, id: \.self) { image in
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            
            PhotosPicker(selection: $viewModel.selectedPhotosPickerItems,
                         maxSelectionCount: 5, selectionBehavior: .ordered,
                         matching: .images) {
                Text("사진 가져오기")
            }
        }
    }
}

#Preview {
    QuestionView(viewModel: QuestionViewModel())
}
