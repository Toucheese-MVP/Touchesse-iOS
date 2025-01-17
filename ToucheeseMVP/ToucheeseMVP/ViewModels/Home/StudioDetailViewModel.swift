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
    
    
    // MARK: - Output
    
    
    // MARK: - Logic
    @MainActor
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
//    
    // MARK: - Migration
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    init(studio: TempStudio) {
        self.studio = studio
    }
     
    // MARK: - Logic
    @MainActor
    func fetchStudioDetail() async {
        do {
            studioDetailEntity = try await networkManager.getStudioDetail(studioID: studio.id)
            print("🥺\(studioDetailEntity)")
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
}
