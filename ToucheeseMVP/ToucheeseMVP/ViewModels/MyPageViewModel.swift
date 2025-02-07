//
//  MyPageViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/23/24.
//

import Foundation
import SafariServices
import Kingfisher

final class MyPageViewModel: ObservableObject {
    private let authManager = AuthenticationManager.shared
    private let networkManager = NetworkManager.shared
    
    @Published private(set) var imageCacheUse: String = ""
    @Published private(set) var appVersionString: String = ""
    private(set) var contactEmailString: String = "toucheese.official@gmail.com"
    
    init() {
        getAppVersionString()
    }
    
    /// 닉네임 수정 요청
    func editNickName(newName: String) async {
        
    }
    
    /// 정책, 개인정보 처리방침 웹 뷰 열기
    func openPolicyWebView() {
        let urlString = "https://silken-cream-988.notion.site/16587345f49a800a8bcfd6522543cffb?pvs=4"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// 오픈 라이선스 웹 뷰 열기
    func openLicenseWebView() {
        let urlString = "https://silken-cream-988.notion.site/16687345f49a80908f60dcabb4eb3089?pvs=4"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// 이미지 캐시량 계산하기
    func calImageCacheUse() {
        ImageCache.default.calculateDiskStorageSize { [self] result in
            switch result {
            case .success(let size):
                let sizeInMB = Double(size) / (1024 * 1024)
                imageCacheUse = String(format: "%.2fMB", sizeInMB)
            case .failure(let error):
                print("ImageCacheStorageError: \(error)")
                imageCacheUse = "0MB"
            }
        }
    }
    
    /// 이미지 캐시 비우기
    func clearImageCache() {
        ImageCache.default.clearCache {
            self.calImageCacheUse()
        }
    }
    
    /// 앱 버젼 가져오기
    private func getAppVersionString() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        appVersionString = "v\(version)"
    }
    
    /// 이메일주소 클립보드에 복사하기
    func copyContactEmail() {
        UIPasteboard.general.string = contactEmailString
    }
    
    /// 로그아웃
    func logout() async {
        // TODO: 로그아웃 로직을 적용해야함

        
//        guard authManager.authStatus == .authenticated else { return }
//        
//        do {
//            _ = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [self] token in
//                // try await networkManager.postLogout(accessToken: token)
//            }
//            
//            await authManager.logout()
//        } catch NetworkError.unauthorized {
//            print("Logout Error: Refresh Token Expired.")
//            await authManager.logout()
//        } catch {
//            print("Logout Error: \(error.localizedDescription)")
//        }
    }
    
    /// 회원탈퇴
    func withdrawal() async {
        // TODO: 회원 탈퇴 로직을 적용해야함
//        guard authManager.authStatus == .authenticated else { return }
//        
//        do {
//            _ = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [self] token in
//
//                // try await networkManager.postWithdrawal(accessToken: token)
//            }
//            
//            await authManager.withdrawal()
//        } catch NetworkError.unauthorized {
//            print("Withdrawal Error: Refresh Token Expired.")
//            await authManager.withdrawal()
//        } catch {
//            print("Withdrawal Error: \(error.localizedDescription)")
//        }
    }
    
    @MainActor
    func changeNickname(newName: String) async {
        // TODO: 닉네임 변경 로직을 적용해야함

//        guard authManager.authStatus == .authenticated else { return }
//        
//        do {
//            _ = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [self] token in
//                if let memberId = authManager.memberId {
//                    let nicknameChangeRequest = NicknameChangeRequest(
//                        accessToken: token,
//                        memberId: memberId,
//                        newName: newName
//                    )
//                    
//                    try await networkManager.putNicknameChange(nicknameChangeRequest)
//                    
//                    authManager.memberNickname = newName
//                } else {
//                    print("Nickname Change Error: memberID is nil")
//                    authManager.logout()
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Nickname Change Error: Refresh Token Expired.")
//            authManager.logout()
//        } catch {
//            print("Nickname Change Error: \(error.localizedDescription)")
//        }
    }
}
