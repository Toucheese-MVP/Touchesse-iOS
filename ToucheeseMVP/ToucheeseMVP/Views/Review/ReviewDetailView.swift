//
//  ReviewDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/2/24.
//

import SwiftUI

struct ReviewDetailView<ViewModel: ReviewDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject private var navigationManager: NavigationManager

    @State var carouselIndex: Int = 0
    @State var isShowingImageExtensionView: Bool = false
    
    let reviewId: Int
    
    var body: some View {
        let reviewDetail = viewModel.reviewDetail
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ImageCarouselView(
                    imageStrings: reviewDetail.reviewImages,
                    carouselIndex: $carouselIndex,
                    isShowingImageExtensionView: $isShowingImageExtensionView,
                    height: 340
                )
                .padding(.bottom, 15)
                
                // 사용자가 작성한 리뷰 뷰
                reviewContentView(reviewDetail: reviewDetail)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .task {
            await viewModel.fetchReviewDetail(studioID: viewModel.studio.id, reviewID: reviewId)
        }
        .customNavigationBar {
            EmptyView()
        } leftView: {
            Button {
                navigationManager.pop(1)
            } label: {
                NavigationBackButtonView()
            }
        }
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageStrings: reviewDetail.reviewImages,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
    }
    
    private func reviewContentView(reviewDetail: ReviewDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
//                ProfileImageView(
//                    imageURL: reviewDetail.userProfileImageURL,
//                    size: 46
//                )
                
                VStack(alignment: .leading, spacing: 3) {
//                    Text(reviewDetail.userName)
//                        .foregroundStyle(.tcGray08)
//                        .font(.pretendardMedium16)
//                    
                    HStack {
                        Image(.tcStarFill)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text(String(format: "%.1f", reviewDetail.rating))
                            .foregroundStyle(.tcGray08)
                            .font(.pretendardMedium14)
                    }
                }
                
                Spacer()
//                
//                VStack {
//                    Text("작성일: \(reviewDetail.dateString.iso8601ToDate?.toString(format: .yearMonthDay) ?? "")")
//                        .foregroundStyle(.tcGray05)
//                        .font(.pretendardRegular12)
//                    
//                    Spacer()
//                }
            }
            .padding(.horizontal, 16)
            
            Text("\(reviewDetail.content)")
                .foregroundStyle(.tcGray08)
                .font(.pretendardRegular14)
                .multilineTextAlignment(.leading)
                .padding(16)
        }
    }
    
//    private func reviewReplyView(
//        reply: Reply?,
//        studio: Studio
//    ) -> some View {
//        VStack(spacing: 20) {
//            if let reply {
//                DividerView(height: 8)
//                
//                VStack(alignment: .leading, spacing: 12) {
//                    HStack(spacing: 4) {
//                        ProfileImageView(
//                            imageURL: studio.profileImageURL,
//                            size: 46
//                        )
//                        
//                        VStack(alignment: .leading, spacing: 3) {
//                            Text(studio.name)
//                                .foregroundStyle(.tcGray10)
//                                .font(.pretendardMedium16)
//                            
//                            Text("작성일: \(reply.dateString.iso8601ToDate?.toString(format: .yearMonthDay) ?? "")")
//                                .foregroundStyle(.tcGray05)
//                                .font(.pretendardRegular12)
//                        }
//                        
//                        Spacer()
//                    }
//                    
//                    Text(reply.content)
//                        .foregroundStyle(.tcGray07)
//                        .font(.pretendardRegular14)
//                        .multilineTextAlignment(.leading)
//                }
//                .padding(16)
//                .background {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(.tcGray01)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(.tcGray02, lineWidth: 1)
//                        }
//                }
//                .padding(.horizontal, 16)
//            }
//        }
//    }
}
