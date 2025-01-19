////
////  ReviewDetailView.swift
////  TOUCHEESE
////
////  Created by Healthy on 12/2/24.
////
//
//import SwiftUI
//
//struct ReviewDetailView: View {
//    @EnvironmentObject var viewModel: StudioDetailViewModel
//    
//    @Environment(\.dismiss) private var dismiss
//    
//    @State var carouselIndex: Int = 0
//    @State var isShowingImageExtensionView: Bool = false
//    
//    var body: some View {
//        let studio = viewModel.studio
//        let reviewDetail = viewModel.reviewDetail
//        let reply = reviewDetail.reply
//        
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack {
//                // 스튜디오 이미지 캐러셸 뷰
//                ImageCarouselView(
//                    imageURLs: reviewDetail.imageURLs,
//                    carouselIndex: $carouselIndex,
//                    isShowingImageExtensionView: $isShowingImageExtensionView,
//                    height: 340
//                )
//                .padding(.bottom, 15)
//                
//                // 사용자가 작성한 리뷰 뷰
//                reviewContentView(reviewDetail: reviewDetail)
//                    .padding(.horizontal, 16)
//                
//                // 사용자가 작성한 리뷰에 대한 스튜디오의 댓글 뷰
//                reviewReplyView(reply: reply, studio: studio)
//                
//                Spacer()
//            }
//        }
//        .customNavigationBar {
//            EmptyView()
//        } leftView: {
//            Button {
//                dismiss()
//            } label: {
//                NavigationBackButtonView()
//            }
//        }
//        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
//            ImageExtensionView(
//                imageURLs: reviewDetail.imageURLs,
//                currentIndex: $carouselIndex,
//                isShowingImageExtensionView: $isShowingImageExtensionView
//            )
//        }
//    }
//    
//    private func reviewContentView(reviewDetail: ReviewDetail) -> some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(spacing: 8) {
//                ProfileImageView(
//                    imageURL: reviewDetail.userProfileImageURL,
//                    size: 46
//                )
//                
//                VStack(alignment: .leading, spacing: 3) {
//                    Text(reviewDetail.userName)
//                        .foregroundStyle(.tcGray08)
//                        .font(.pretendardMedium16)
//                    
//                    HStack {
//                        Image(.tcStarFill)
//                            .resizable()
//                            .frame(width: 14, height: 14)
//                        
//                        Text(String(format: "%.1f", reviewDetail.rating))
//                            .foregroundStyle(.tcGray08)
//                            .font(.pretendardMedium14)
//                    }
//                }
//                
//                Spacer()
//                
//                VStack {
//                    Text("작성일: \(reviewDetail.dateString.iso8601ToDate?.toString(format: .yearMonthDay) ?? "")")
//                        .foregroundStyle(.tcGray05)
//                        .font(.pretendardRegular12)
//                    
//                    Spacer()
//                }
//            }
//            .padding(.horizontal, 16)
//            
//            Text("\(reviewDetail.content ?? "")")
//                .foregroundStyle(.tcGray08)
//                .font(.pretendardRegular14)
//                .multilineTextAlignment(.leading)
//                .padding(16)
//        }
//    }
//    
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
//}
//
//#Preview {
//    NavigationStack {
//        ReviewDetailView()
//            .environmentObject(
//                StudioDetailViewModel(studio: Studio.sample, tempStudioData: TempStudio.sample)
//            )
//    }
//}
