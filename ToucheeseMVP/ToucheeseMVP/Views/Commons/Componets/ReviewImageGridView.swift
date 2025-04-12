//
//  ImageGridView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/30/24.
//

import SwiftUI
import Kingfisher

struct ReviewImageGridView<ViewModel: StudioDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    let reviews: [StudioReviewEntity]?
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    private var gridSize: CGFloat {
        (CGFloat.screenWidth - (32 + 16)) / 3
    }
    
    var body: some View {
        if let reviews {
            VStack(alignment: .leading, spacing: 16) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(reviews, id: \.self) { review in
                        if let url = URL(string: review.firstImage) {
                            KFImage(url)
                                .placeholder { ProgressView() }
                                .downsampling(size: CGSize(width: 200, height: 200))
                                .cacheMemoryOnly()
                                .cancelOnDisappear(true)
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: gridSize, height: 144)
                                .clipShape(.rect(cornerRadius: 6))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    navigationManager
                                        .appendPath(
                                            viewType: .reviewDetailView(
                                                studio: viewModel.studio,
                                                reviewId: review.id
                                            ),
                                            viewMaterial: nil
                                        )
                                }
                        }
                    }
                }
                
                Color.clear
                    .frame(height: 30)
            }
        } else {
            CustomEmptyView(viewType: .review)
        }
    }
}
