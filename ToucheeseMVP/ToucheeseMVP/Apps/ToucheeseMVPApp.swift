//
//  ToucheeseMVPApp.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/9/25.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: - Firebase 관련 설정
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // MARK: - Push Notification 권한 설정
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        // 앱에서 알림 권한을 요청하는 메서드
        center.requestAuthorization(options: authOptions) { granted, error in
            guard error == nil else {
                print("Error while requesting permission for notifications.")
                return
            }
            
            if granted {
                print("Authorization granted.")
                DispatchQueue.main.async {
                    // APNs에 등록
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Authorization denied or undetermined.")
            }
        }
        
        return true
    }
    
    // 디바이스가 APNs 등록에 실패했을 때 호출되는 메서드
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        print(error.localizedDescription)
    }
    
    // 디바이스가 APNs 등록에 성공했을 때 호출되는 메서드
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        #if DEBUG
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(deviceTokenString)
        #endif
        
        // APN 토큰을 명시적으로 FCM 등록 토큰에 매핑하는 코드
        Messaging.messaging().apnsToken = deviceToken
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate { }


extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        #if DEBUG
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)
        #endif
    }
}


@main
struct ToucheeseMVPApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var reservationListViewModel = ReservationListViewModel()
    @StateObject private var mypageViewModel = MyPageViewModel()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var studioLikeListViewModel = StudioLikeListViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let keychainManager = KeychainManager.shared
    private let networkManager = NetworkManager.shared
    private let authManager = AuthenticationManager.shared
    
    init() {
        CacheManager.configureKingfisherCache()
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(reservationListViewModel)
                .environmentObject(mypageViewModel)
                .environmentObject(navigationManager)
                .environmentObject(studioLikeListViewModel)
                .preferredColorScheme(.light)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .task {
                    switch await checkAuthentication() {
                    case .authenticated:
                        AuthenticationManager.shared.successfulAuthentication()
                        await reservationListViewModel.fetchReservations()
                        await reservationListViewModel.fetchPastReservations()
                        await studioLikeListViewModel.fetchLikedStudios()
                    case .notAuthenticated:
                        AuthenticationManager.shared.failedAuthentication()
                    }
                }
        }
    }
}


extension ToucheeseMVPApp {
    /// 앱을 처음 실행했을 때, 로그인 상태를 확인하는 메서드
    private func checkAuthentication() async -> AuthStatus {
        guard let accessToken = keychainManager.read(forAccount: .accessToken),
              let refreshToken = keychainManager.read(forAccount: .refreshToken) else {
            return .notAuthenticated
        }
        
        do {
            let appOpenRequest = AppOpenRequest(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            let appOpenResponse = try await networkManager.postAppOpen(
                appOpenRequest
            )
            
            keychainManager.update(
                token: appOpenResponse.accessToken,
                forAccount: .accessToken
            )
            
            #if DEBUG
            print("New access token: \(appOpenResponse.accessToken)")
            print("member ID: \(appOpenResponse.memberId)")
            #endif
            
            authManager.memberId = appOpenResponse.memberId
            authManager.memberNickname = appOpenResponse.memberName
            
            postDeviceTokenRegistrationData()
            
            return .authenticated
        } catch {
            print("AccessToken refresh failed: \(error.localizedDescription)")
            return .notAuthenticated
        }
    }
    
    /// FCM 토큰을 백엔드 서버에 POST 하는 메서드
    private func postDeviceTokenRegistrationData() {
        Task {
            if let fcmToken = Messaging.messaging().fcmToken,
               let memberId = authManager.memberId {
                do {
                    try await networkManager.performWithTokenRetry(
                        accessToken: authManager.accessToken,
                        refreshToken: authManager.refreshToken
                    ) { token in
                        let deviceTokenRegistrationRequest = DeviceTokenRegistrationRequest(
                            memberId: memberId,
                            deviceToken: fcmToken
                        )
                        try await networkManager.postDeviceTokenRegistrationData(
                            deviceTokenRegistrationRequest: deviceTokenRegistrationRequest,
                            accessToken: token
                        )
                    }
                } catch {
                    print("Post DeviceTokenRegistrationData failed: \(error.localizedDescription)")
                    authManager.logout()
                }
            }
        }
    }
}
