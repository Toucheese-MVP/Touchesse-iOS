//
//  ImageSelectView.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/1/25.
//

import SwiftUI
import PhotosUI

struct ImageSelectView<ImageViewModel: ImageUploadViewModelProtocol>: View {
    @ObservedObject var imageViewModel: ImageViewModel
    
    var body: some View {
        if imageViewModel.isLoadingImage {
            ProgressView()
                .frame(width: 84, height: 84)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(imageViewModel.displaySelectedUIImageContents, id: \.originalIndex) { content in
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
                                            await imageViewModel.deleteSelectedImage(originalIndex: content.originalIndex)
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
                    
                    if imageViewModel.selectedPhotosPickerItems.count < 5 {
                        PhotosPicker(selection: $imageViewModel.selectedPhotosPickerItems,
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
                                        Text("\(imageViewModel.selectedPhotosPickerItems.count)/5")
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
