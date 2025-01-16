//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    // MARK: - Data
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail = StudioDetail.sample
    @Published private(set) var reviewDetail: ReviewDetail = ReviewDetail.sample
    
    
    // MARK: - Output
    var businessHourString: String {
        var basicString = "\(studioDetail.openTimeString)~\(studioDetail.closeTimeString)"
        
        if !studioDetail.holidayString.isEmpty {
            basicString += " / 매주 \(studioDetail.holidayString) 휴무"
        } else {
            basicString += " / 휴무일 없음"
        }
        
        return basicString
    }
    
    // MARK: - Logic
    @MainActor
    func fetchReviewDetail(reviewID: Int) async {
        do {
            reviewDetail = try await networkManager.getReviewDetailData(
                studioID: studio.id,
                reviewID: reviewID
            )
        } catch {
            print("Fetch ReviewDetail Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Migration
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    init(studio: Studio, tempStudioData: TempStudio) {
        self.studio = studio
        self.tempStudioData = tempStudioData
        
        Task {
            await fetchStudioDetail(studioID: studio.id)
        }
    }
    
    // MARK: - Data: Studio
    @Published private(set) var tempStudioData: TempStudio
    @Published private(set) var studioDetailEntity: StudioDetailEntity = StudioDetailEntity.sample
    
    
    // MARK: - Logic
    @MainActor
    private func fetchStudioDetail(studioID: Int) async {
        do {
            studioDetailEntity = try await networkManager.getStudioDetail(studioID: studioID)
            print("\(studioDetailEntity)")
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
}
