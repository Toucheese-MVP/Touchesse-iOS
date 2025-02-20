//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    // MARK: - Data
    @Published private(set) var studio: Studio = Studio.sample
    @Published private(set) var studioDetailEntity: StudioDetailEntity = StudioDetailEntity.sample
//    @Published private(set) var reviewDetail: ReviewDetail = ReviewDetail.sample
    
    private let studioService = DefaultStudioService(session: SessionManager.shared.baseSession)
    
    let studioId: Int?
    
    init(studio: Studio?, studioId: Int?) {
        self.studio = studio ?? Studio.sample
        self.studioId = studioId
    }
     
    // MARK: - Logic
//    @MainActor
//    func fetchReviewDetail(reviewID: Int) async {
//        do {
//            reviewDetail = try await networkManager.getReviewDetailData(
//                studioID: studio.id,
//                reviewID: reviewID
//            )
//        } catch {
//            print("Fetch ReviewDetail Error: \(error.localizedDescription)")
//        }
//    }

    @MainActor
    func fetchStudioDetail() async {
        do {
            studioDetailEntity = try await studioService.getStudioDetail(studioID: studioId ?? studio.id)
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
}
