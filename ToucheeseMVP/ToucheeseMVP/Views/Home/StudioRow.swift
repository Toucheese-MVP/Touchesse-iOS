//
//  StudioRow.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/14/24.
//

import SwiftUI
import Kingfisher

struct StudioRow: View {
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    @EnvironmentObject private var studioLikeListViewModel: StudioLikeListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private let authManager = AuthenticationManager.shared
    
    let studio: Studio
    private var portfolioImageURLs: [URL] {
        studio.portfolioImageURLs
    }
    
    @Binding var isShowingLoginAlert: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ProfileImageView(
                    imageURL: studio.profileImageURL,
                    size: 50
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(studio.name)")
                        .foregroundStyle(.tcGray10)
                        .font(.pretendardMedium(17))
                    
                    HStack(spacing: 0) {
                        Image(.tcStarFill)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .padding(.trailing, 3)
                        
                        Text(studio.formattedRating)
                            .foregroundStyle(.tcGray10)
                            .font(.pretendardSemiBold14)
                        
                        Text("(\(studio.reviewCount))")
                            .foregroundStyle(.tcGray05)
                            .font(.pretendardRegular14)
                    }
                }
                
                Spacer()
                
                Button {
                    if authManager.authStatus == .notAuthenticated {
                        isShowingLoginAlert.toggle()
                        navigationManager.isShowingAlert = true
                    } else {
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
                    }
                } label: {
                    Image(authManager.memberLikedStudios.contains(studio) ? .tcBookmarkFill : .tcBookmark)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            
            portfolioImagesScrollView(portfolioImageURLs)
        }
    }
    
    @ViewBuilder
    private func portfolioImagesScrollView(_ imageURLs: [URL]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 6.5) {
                ForEach(imageURLs.indices, id: \.self) { index in
                    KFImage(imageURLs[index])
                        .placeholder { ProgressView() }
                        .resizable()
                        .downsampling(size: CGSize(width: 230, height: 230))
                        .cancelOnDisappear(true)
                        .fade(duration: 0.25)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 116, height: 116)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    StudioRow(studio: Studio.sample, isShowingLoginAlert: .constant(false))
}
