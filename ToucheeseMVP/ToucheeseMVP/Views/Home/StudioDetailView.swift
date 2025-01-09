//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct StudioDetailView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    @EnvironmentObject private var studioLikeListViewModel: StudioLikeListViewModel
    @StateObject var viewModel: StudioDetailViewModel
    
    @Environment(\.isPresented) private var isPresented
    @Environment(\.dismiss) private var dismiss
    
    @Namespace private var namespace
    
    @State private var selectedSegmentedControlIndex = 0
    @State private var carouselIndex = 0
    @State private var isShowingImageExtensionView = false
    @State private var isExpanded = false
    @State private var isPushingReviewDetailView = false
    @State private var isBookmarked = false
    
    @State private var isShowingLoginAlert: Bool = false
    @State private var isShowingLoginView: Bool = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        let studio = viewModel.studio
        let studioDetail = viewModel.studioDetail
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ImageCarouselView(
                        imageURLs: studioDetail.detailImageURLs,
                        carouselIndex: $carouselIndex,
                        isShowingImageExtensionView: $isShowingImageExtensionView,
                        height: 280
                    )
                    .padding(.bottom, 16)
                    
                    // Studio 설명 View
                    VStack(alignment: .leading, spacing: 8) {
                        Text(studio.name)
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardSemiBold18)
                            .padding(.bottom, 4)
                        
                        HStack(spacing: 4) {
                            Image(.tcStarFill)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            
                            Text(studio.formattedRating)
                                .foregroundStyle(.tcGray10)
                                .font(.pretendardSemiBold16)
                            
                            Text("(\(studio.reviewCount))")
                                .foregroundStyle(.tcGray10)
                                .font(.pretendardRegular16)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.tcGray01)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(.tcGray02, lineWidth: 1)
                                }
                        )
                        .onTapGesture {
                            selectedSegmentedControlIndex = 1
                        }
                        
                        HStack(spacing: 4) {
                            Image(.tcClock)
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text(viewModel.businessHourString)
                                .foregroundStyle(.tcGray08)
                                .font(.pretendardRegular16)
                        }
                        
                        HStack(alignment: .top, spacing: 4) {
                            Image(.tcMapPinFill)
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text(studioDetail.address)
                                .foregroundStyle(.tcGray08)
                                .font(.pretendardRegular16)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // Studio 공지 View
                    if let notice = studioDetail.notice, notice != "" {
                        NoticeView(notice: notice, isExpanded: $isExpanded)
                            .padding(.bottom, 24)
                            .padding(.horizontal, 16)
                    }
                    
                    CustomSegmentedControl(
                        selectedIndex: $selectedSegmentedControlIndex,
                        namespace: namespace,
                        options: ["상품", "리뷰(\(studioDetail.reviewCount))"]
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // 상품 또는 리뷰 View
                    if selectedSegmentedControlIndex == 0 {
                        ProductListView(
                            studioDetail: studioDetail,
                            studio: studio
                        )
                        .environmentObject(viewModel)
                        .padding(.horizontal, 16)
                    } else {
                        ReviewImageGridView(
                            reviews: studioDetail.reviews.content,
                            reviewsCount: studioDetail.reviewCount,
                            isPushingDetailView: $isPushingReviewDetailView
                        )
                        .environmentObject(viewModel)
                        .padding(.horizontal, 16)
                    }
                }
            }
            .customNavigationBar(
                centerView: {
                    EmptyView()
                },
                leftView: {
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                            NavigationBackButtonView()
                        }
                        .padding(.trailing, 11)
                        
                        ProfileImageView(
                            imageURL: studio.profileImageURL,
                            size: 36
                        )
                        .padding(.trailing, 8)
                        
                        Text(studio.name)
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardBold20)
                    }
                },
                rightView: {
                    Button {
                        if authManager.authStatus == .notAuthenticated {
                            isShowingLoginAlert.toggle()
                        }
                        Task {
                            if authManager.memberLikedStudios.contains(studio) {
                                await studioListViewModel.cancelLikeStudio(
                                    studioId: studio.id
                                )
                            } else {
                                await studioListViewModel.likeStudio(
                                    studioId: studio.id
                                )
                            }
                            
                            await studioLikeListViewModel.fetchLikedStudios()
                        }
                    } label: {
                        Image(authManager.memberLikedStudios.contains(studio) ? .tcBookmarkFill : .tcBookmark)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(.plain)
                }
            )
            
            if isShowingLoginAlert {
                CustomAlertView(
                    isPresented: $isShowingLoginAlert,
                    alertType: .login
                ) {
                    isShowingLoginView.toggle()
                }
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .fullScreenCover(isPresented: $isShowingLoginView) {
            LogInView(isPresented: $isShowingLoginView)
        }
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageURLs: studioDetail.detailImageURLs,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
        .navigationDestination(isPresented: $isPushingReviewDetailView) {
            ReviewDetailView()
                .environmentObject(viewModel)
        }
    }
    
    private func leadingToolbarContent(
        for studio: Studio
    ) -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 35
                )
                
                Text("\(studio.name)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var trailingToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bookmark")
                }
            }
        }
    }
}


fileprivate struct CustomSegmentedControl: View {
    @Binding var selectedIndex: Int
    let namespace: Namespace.ID
    let options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack(alignment: .bottom) {
                    Text(options[index])
                        .font(selectedIndex == index ? .pretendardSemiBold16 : .pretendardRegular16)
                        .foregroundStyle(selectedIndex == index ? .tcPrimary06 : .tcGray05)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .contentShape(.rect)
                        .onTapGesture {
                            selectedIndex = index
                        }
                    
                    if selectedIndex == index {
                        Rectangle()
                            .fill(selectedIndex == index ? .tcPrimary06 : .tcGray03)
                            .frame(height: selectedIndex == index ? 3 : 1.5)
                            .matchedGeometryEffect(
                                id: "rect",
                                in: namespace
                            )
                    }
                }
                .animation(.spring(), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.tcGray04)
                .frame(height: 1.5)
        }
    }
}


fileprivate struct ProductListView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let studioDetail: StudioDetail
    let studio: Studio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("촬영 상품")
                .foregroundStyle(.tcGray10)
                .font(.pretendardMedium18)
            
            ForEach(studioDetail.products, id: \.self) { product in
                Button {
                    navigationManager.appendPath(viewType: .productDetailView, viewMaterial: ProductDetailViewMaterial(viewModel: ProductDetailViewModel(studio: studio, studioDetails: studioDetail, product: product)))
                } label: {
                    HStack(spacing: 13) {
                        KFImage(product.imageURL)
                            .placeholder { ProgressView() }
                            .resizable()
                            .downsampling(size: CGSize(width: 250, height: 250))
                            .fade(duration: 0.25)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 85, height: 120)
                            .clipShape(.rect(cornerRadius: 8))
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .foregroundStyle(.tcGray08)
                                .font(.pretendardSemiBold16)
                                .padding(.bottom, 4)
                            
                            Text(product.description)
                                .foregroundStyle(.tcGray06)
                                .font(.pretendardRegular13)
                                .lineLimit(2)
                                .lineSpacing(0)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                            
                            HStack(spacing: 2) {
                                Image(.tcReview)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                Text("리뷰 \(product.reviewCount)개")
                                    .foregroundStyle(.tcGray08)
                                    .font(.pretendardMedium12)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.tcGray01)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(.tcGray02, lineWidth: 1)
                                    )
                            )
                            
                            Spacer()
                            
                            Text("\(product.price)원")
                                .foregroundStyle(.tcGray10)
                                .font(.pretendardSemiBold18)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 123)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.tcGray02, lineWidth: 1)
                    )
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 4)
            }
            
            Color.clear
                .frame(height: 30)
        }
    }
}


fileprivate struct NoticeView: View {
    let notice: String?
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Image(.tcSpeaker)
                .resizable()
                .frame(width: 24, height: 24)
            
            if let notice {
                Text("\(notice)")
                    .font(.pretendardRegular14)
                    .foregroundStyle(.tcGray07)
                    .padding(.top, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(isExpanded ? nil : 1)
                    .multilineTextAlignment(.leading)
                
                if notice.count > 26 {
                    Image(isExpanded ? .tcTriangleUp : .tcTriangleDown)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.tcGray01)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.tcGray02, lineWidth: 1)
                }
        }
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}


#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample)
        )
        .environmentObject(NavigationManager())
    }
}
