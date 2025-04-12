//
//  StudioDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct StudioDetailView<ViewModel: StudioDetailViewModelProtocol>: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    @EnvironmentObject private var studioLikeListViewModel: StudioLikeListViewModel
    @ObservedObject var viewModel: ViewModel
    
    @Namespace private var namespace
    
    @State private var selectedSegmentedControlIndex = 0
    @State private var carouselIndex = 0
    @State private var isShowingImageExtensionView = false
    @State private var isExpanded = false
    @State private var isBookmarked = false
    
    @State private var isShowingLoginAlert: Bool = false
    @State private var isShowingLoginView: Bool = false
    @State private var isShowingWorkingTime: Bool = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ImageCarouselView(
                        imageStrings: viewModel.studioDetailEntity.facilityImageUrls,
                        carouselIndex: $carouselIndex,
                        isShowingImageExtensionView: $isShowingImageExtensionView,
                        height: 280
                    )
                    .padding(.bottom, 16)
                    
                    // Studio 설명 View
                    VStack(alignment: .leading, spacing: 8) {
                        
                        studioNameView
                        ratingReviewView
                        locationView
                        workingTimeToggleButton
                        
                        if isShowingWorkingTime {
                            workingTimeView
                        }
                        
                        if viewModel.studioDetailEntity.notice != "" {
                            NoticeView(notice: viewModel.studioDetailEntity.notice, isExpanded: $isExpanded)
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    CustomSegmentedControl(
                        selectedIndex: $selectedSegmentedControlIndex,
                        namespace: namespace,
                        options: ["상품", "리뷰"]
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // 상품 또는 리뷰 View
                    if selectedSegmentedControlIndex == 0 {
                        ProductListView(
                            studioDetail: viewModel.studioDetailEntity,
                            studio: viewModel.studio
                        )
                        .environmentObject(viewModel)
                        .padding(.horizontal, 16)
                    } else {
                        ReviewImageGridView(
                            viewModel: viewModel,
                            reviews: viewModel.reviewList
                        )
                        .padding(.horizontal, 16)
                    }
                }
            }
            .customNavigationBar(
                centerView: {
                    EmptyView()
                },
                leftView: {
                    BackbButtonView()
                }
                //                ,
                //                rightView: {
                //                    Button {
                //                        //                        if authManager.authStatus == .notAuthenticated {
                //                        //                            isShowingLoginAlert.toggle()
                //                        //                        }
                //                        //                        Task {
                //                        //                            if authManager.memberLikedStudios.contains(studio) {
                //                        //                                await studioListViewModel.cancelLikeStudio(
                //                        //                                    studioId: studio.id
                //                        //                                )
                //                        //                            } else {
                //                        //                                await studioListViewModel.likeStudio(
                //                        //                                    studioId: studio.id
                //                        //                                )
                //                        //                            }
                //                        //
                //                        //                            await studioLikeListViewModel.fetchLikedStudios()
                //                        //                        }
                //                    } label: {
                //                        Image(/*authManager.memberLikedStudios.contains(studio) ? .tcBookmarkFill :*/ .tcBookmark)
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(width: 30, height: 30)
                //                    }
                //                    .buttonStyle(.plain)
                //                }
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
            LoginView(TviewModel: LogInViewModel(),
                      isPresented: $isShowingLoginView)
        }
        .fullScreenCover(isPresented: $isShowingImageExtensionView) {
            ImageExtensionView(
                imageStrings: viewModel.studioDetailEntity.facilityImageUrls,
                currentIndex: $carouselIndex,
                isShowingImageExtensionView: $isShowingImageExtensionView
            )
        }
    }
    
}

extension StudioDetailView {
    private var studioNameView: some View {
        HStack(spacing: 9) {
            ProfileImageView(
                imageString: viewModel.studioDetailEntity.profileImage,
                size: 36
            )
            
            Text(viewModel.studioDetailEntity.name)
                .foregroundStyle(.tcGray10)
                .font(.pretendardSemiBold18)
        }
        .padding(.bottom, 8)
    }
    
    private var ratingReviewView: some View {
        HStack {
            HStack(spacing: 4) {
                Image(.tcStarFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(String(format: "%.1f", viewModel.studioDetailEntity.rating))
                    .foregroundStyle(.tcGray10)
                    .font(.pretendardSemiBold16)
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
            
            //            Text("리뷰 \(viewModel.studioDetailEntity.reviewCount)개 >")
            //                .foregroundStyle(.tcGray10)
            //                .font(.pretendardRegular16)
        }
        .padding(.bottom, 4)
    }
    
    private var locationView: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(.tcMapPinFill)
                .resizable()
                .frame(width: 18, height: 18)
            
            Text(viewModel.studioDetailEntity.address)
                .foregroundStyle(.tcGray08)
                .font(.pretendardRegular16)
                .multilineTextAlignment(.leading)
        }
        .padding(.bottom, 4)
    }
    
    private var workingTimeToggleButton: some View {
        HStack(spacing: 4) {
            Image(.tcClock)
                .resizable()
                .frame(width: 18, height: 18)
            HStack {
                Text(viewModel.studioDetailEntity.isOpen ? "영업 중" : "영업 마감")
                    .foregroundStyle(.tcGray08)
                    .font(.pretendardRegular16)
                Image(isShowingWorkingTime ? .tcTriangleUp : .tcTriangleDown)
            }
            .onTapGesture {
                isShowingWorkingTime.toggle()
            }
        }
    }
    
    private var workingTimeView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.studioDetailEntity.operatingHours, id: \.self) { time in
                Text("(\(time.dayOfWeek)) \(time.openTime) ~ \(time.closeTime)")
                    .font(.pretendardMedium14)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.white
                .mask(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .tcGray03 ,radius: 4)
            
        }
        .padding(.top, 12)
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
    let studioDetail: StudioDetailEntity
    let studio: Studio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("촬영 상품")
                .foregroundStyle(.tcGray10)
                .font(.pretendardMedium18)
            
            ForEach(studioDetail.products, id: \.self) { product in
                productCell(product: product)
            }
            
            Color.clear
                .frame(height: 30)
        }
    }
    
    private func productCell(product: ProductEntity) -> some View {
        Button {
            navigationManager.appendPath(
                viewType: .productDetailView(studio: studio, studioDetail: studioDetail, product: product),
                viewMaterial: nil
            )
        } label: {
            HStack(spacing: 13) {
                if let imageURL = URL(string: product.productImage) {
                    KFImage(imageURL)
                        .placeholder { ProgressView() }
                        .resizable()
                        .downsampling(size: CGSize(width: 250, height: 250))
                        .fade(duration: 0.25)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 85, height: 120)
                        .clipShape(.rect(cornerRadius: 8))
                }
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
                    
                    //                    HStack(spacing: 2) {
                    //                        Image(.tcReview)
                    //                            .resizable()
                    //                            .frame(width: 16, height: 16)
                    //
                    //                        Text("리뷰 \(product.reviewCount)개 >")
                    //                            .foregroundStyle(.tcGray08)
                    //                            .font(.pretendardMedium12)
                    //                    }
                    //                    .padding(.vertical, 4)
                    //                    .padding(.horizontal, 8)
                    
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
}


fileprivate struct NoticeView: View {
    let notice: String?
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(.tcSpeaker)
            
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
        .padding(.vertical, 16)
        .padding(.horizontal, 27)
        .frame(maxWidth: .infinity)
        .background(.tcGray01, in: RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}
