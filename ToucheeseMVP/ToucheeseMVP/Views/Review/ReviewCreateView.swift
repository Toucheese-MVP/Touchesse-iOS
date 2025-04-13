//
//  ReviewCreateView.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/1/25.
//

import SwiftUI
import PhotosUI

struct ReviewCreateView<ViewModel: ReviewCreateViewModelProtocol, ImageViewModel: ImageUploadViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var imageViewModel: ImageViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private var selectable: Bool {
        (viewModel.rating == 0 ||
        viewModel.content.isEmpty ||
        imageViewModel.selectedPhotosPickerItems.isEmpty ||
        imageViewModel.isLoadingImage)
        ? false : true
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    ReservationRow(reservation: viewModel.reservation)
                    
                    Rectangle()
                        .frame(height: 8)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.tcGray01)
                        .padding(.horizontal, -16)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(viewModel.reservation.studioName)
                                .bold()
                            Text("의")
                        }
                        Text("촬영 경험은 어떠셨나요?")
                        
                        StarRatingView(rating: $viewModel.rating)
                            .padding(.top, 8)
                    }
                    .font(.pretendardMedium(20))
                    
                    Rectangle()
                        .frame(height: 8)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.tcGray01)
                        .padding(.horizontal, -16)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("리뷰 작성")
                            .font(.pretendardSemiBold16)
                        MultiLineTextFieldView(inputValue: $viewModel.content,
                                               placeHolder: "리뷰 내용을 입력해주세요",
                                               width: CGFloat.screenWidth - (16 * 2))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("후기 사진")
                            .font(.pretendardSemiBold16)
                        ImageSelectView(imageViewModel: imageViewModel)
                        Text("최대 5장까지 등록할 수 있어요.")
                            .font(.pretendardRegular13)
                            .foregroundStyle(.tcGray06)
                    }
                    
                    HStack {
                        FillBottomButton(isSelectable: selectable, title: "작성 완료") {
                            Task {
                                let imageData = await imageViewModel.getDownSizedImageData()
                                await viewModel.postReview(imageData)
                                navigationManager.goFirstView()
                            }
                        }
                    }
                    .padding(.top, 43)
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .customNavigationBar {
                Text("리뷰 작성하기")
                    .font(.pretendardBold(20))
                    .foregroundStyle(.tcGray10)
            } leftView: {
                Button {
                    navigationManager.pop(1)
                } label: {
                    NavigationBackButtonView()
                }
            }
            
            if viewModel.isPosting {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundStyle(Color.black.opacity(0.1))
                    
                    ProgressView()
                }
            }
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(0..<5) { num in
                Image(num >= rating ? .tcStarGray : .tcStarFill)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        rating = num + 1
                    }
            }
        }
    }
}

#Preview {
    ReviewCreateView(
        viewModel: ReviewCreateViewModel(reservation: .init(
            reservationId: 0,
            studioId: 0,
            studioName: "스튜디오 이름",
            studioImage: "",
            productId: 0,
            productName: "촬영 상품",
            createDate: "2024-11-11",
            createTime: "14:00",
            status: ""
        )),
        imageViewModel: ImageUploadViewModel()
    )
}
