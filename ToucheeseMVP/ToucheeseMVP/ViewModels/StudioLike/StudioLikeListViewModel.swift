//
//  StudioLikeListViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/26/24.
//

import Foundation

final class StudioLikeListViewModel: ObservableObject {
    
    @Published private(set) var likedStudios: [Studio] = [] {
        didSet {
            authManager.memberLikedStudios = likedStudios
        }
    }
    
    private let authManager = AuthenticationManager.shared
    private let networkManager = NetworkManager.shared
    
    @MainActor
    func fetchLikedStudios() async {
        guard authManager.authStatus == .authenticated else {
            print("Failed to fetch liked studios: Not authenticated")
            return
        }
        
        
        // MARK: 좋아요 누른 스튜디오 불러오는 로직 적용해야 함
//        do {
//            likedStudios = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [unowned self] token in
//                if let memberId = authManager.memberId {
//                    return try await networkManager.getStudioLikeList(
//                        accessToken: token,
//                        memberId: memberId
//                    )
//                } else {
//                    print("Failed to fetch liked studios: Member ID not found")
//                    return []
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Failed to fetch liked studios: Refresh token expired")
//            authManager.logout()
//        } catch {
//            print("Failed to fetch liked studios: \(error.localizedDescription)")
//        }
    }
    
}
