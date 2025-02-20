//
//  MyPageViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/17/25.
//

import Foundation
import UIKit
import Kingfisher

protocol MyPageViewModelProtocol: ObservableObject {
    /// 이미지 캐시 사용량
    var imageCacheUse: String { get }
    /// 앱 버젼
    var appVersionString: String { get }
    /// 문의 이메일
    var contactEmailString: String { get }
    
    /// 로그아웃
    func logout() async
    /// 회원탈퇴
    func withdrawl() async
    /// 이미지 캐시량 계산하기
    func calImageCacheUse()
    /// 이미지 캐시 비우기
    func clearImageCache()
    /// 이메일 주소 클립보드에 복사하기
    func copyContactEmail()
    /// 정책, 개인정보 처리방침 웹 뷰 열기
    func openPolicyWebView()
    /// 오픈 라이선스 웹 뷰 열기
    func openLicenseWebView()
}

protocol PrivateMyPageViewModelProtocol {
    /// 앱 버젼 적용하기
    func setAppVersionString()
    /// 애플 로그아웃 처리
    func handleAppleWithdraw() async
    /// 카카오 로그아웃 처리
    func handleKakaoWithdraw() async
}


final class TempMyPageViewModel: MyPageViewModelProtocol, PrivateMyPageViewModelProtocol {
    let tokenService = DefualtTokenService(session: SessionManager.shared.authSession)
    let memberService = DefaultMemberService(session: SessionManager.shared.authSession)
    let authManager = AuthenticationManager.shared
    
    @Published private(set) var imageCacheUse: String = ""
    @Published private(set) var appVersionString: String = ""
    var contactEmailString: String = "toucheese.official@gmail.com"
    
    init() {
        setAppVersionString()
    }
    
    /// 로그아웃 처리
    /// 모든 상태에서 강제 로그아웃 처리중(서버와 통신에 실패해도 로그아웃 처리 가능)
    func logout() async {
        // 디바이스 Id 못찾을 시 강제 로그아웃
        guard let deviceId = authManager.deviceID else {
            await authManager.resetAllAuthDatas()
            return
        }
        
        // 서버로 로그아웃 요청 전송
        do {
            let result = try await tokenService.postSocialLogout(deviceId)
            
            // 로그아웃 요청 성공시 로그아웃, 실패시에도 강제 로그아웃
            if result == "회원 로그아웃이 완료되었습니다." {
                await authManager.resetAllAuthDatas()
            } else {
                print("로그아웃 서버 전송 결과 실패\n 강제 로그아웃 처리")
                await authManager.resetAllAuthDatas()
            }
        } catch {
            // 로그아웃 요청 실패시에도 강제 로그아웃
            await authManager.resetAllAuthDatas()
            print("로그아웃 서버 전송 에러: \(error.localizedDescription)\n 강제 로그아웃 처리")
        }
    }
    
    func withdrawl() async {
        // 로그인된 플랫폼 확인
        guard let loginedPlatform = authManager.loginedPlatform else {
            return
        }
        
        // 회원 탈퇴 처리
        await handleWithdraw(loginedPlatform)
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
    
    /// 이메일주소 클립보드에 복사하기
    func copyContactEmail() {
        UIPasteboard.general.string = contactEmailString
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
    
    /// 앱 버젼 적용하기
    func setAppVersionString() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        appVersionString = "v\(version)"
    }
    
    /// 회원탈퇴 처리
    private func handleWithdraw(_ loginedPlatform: SocialType) async {
        switch loginedPlatform {
        case .KAKAO:
            await handleKakaoWithdraw()
        case .APPLE:
            await handleAppleWithdraw()
        }
    }
    
    /// 애플 회원탈퇴 처리
    func handleAppleWithdraw() async {
        do {
            try await memberService.cleanupUser()
        } catch {
            print("postAppleWithdraw ERROR: \(error.localizedDescription)")
        }
        
        // 회원 정보 삭제
        await authManager.resetAllAuthDatas()
    }
    
    /// 카카오 회원탈퇴 처리
    func handleKakaoWithdraw() async {
        do {
            try await memberService.cleanupUser()
        } catch {
            print("postAppleWithdraw ERROR: \(error.localizedDescription)")
        }
        
        // 회원 정보 삭제
        await authManager.resetAllAuthDatas()
    }
}
