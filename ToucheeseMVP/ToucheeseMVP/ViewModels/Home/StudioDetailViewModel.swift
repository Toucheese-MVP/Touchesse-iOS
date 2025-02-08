//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    // MARK: - Data
    @Published private(set) var studio: TempStudio = TempStudio.sample
    @Published private(set) var studioDetailEntity: StudioDetailEntity = StudioDetailEntity.sample
//    @Published private(set) var reviewDetail: ReviewDetail = ReviewDetail.sample
    
    let networkManager = NetworkManager.shared
    let studioId: Int?
    
    init(studio: TempStudio?, studioId: Int?) {
        self.studio = studio ?? TempStudio.sample
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
            studioDetailEntity = try await networkManager.getStudioDetail(studioID: studioId ?? studio.id)
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
}
