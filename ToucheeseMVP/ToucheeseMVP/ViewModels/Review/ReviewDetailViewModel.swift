//
//  ReviewDetailViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/13/25.
//

import Foundation

protocol ReviewDetailViewModelProtocol: ObservableObject {
    var studio: Studio { get }
    var reviewDetail: ReviewDetailEntity { get }
    
    func fetchReviewDetail(studioID: Int, reviewID: Int) async
}

final class ReviewDetailViewModel: ReviewDetailViewModelProtocol {
    private let studioService = DefaultStudioService(session: SessionManager.shared.baseSession)
    
    let studio: Studio
    @Published private(set) var reviewDetail: ReviewDetailEntity = .init(id: 0, content: "", rating: 0, reviewImages: [])
    
    init(studio: Studio) {
        self.studio = studio
    }
    
    @MainActor
    func fetchReviewDetail(studioID: Int, reviewID: Int) async {
        do {
            reviewDetail = try await studioService.getReviewDetail(studioId: studioID, reviewId: reviewID)
        } catch {
            print("Fetch ReviewDetail Error: \(error.localizedDescription)")
        }
    }
}
