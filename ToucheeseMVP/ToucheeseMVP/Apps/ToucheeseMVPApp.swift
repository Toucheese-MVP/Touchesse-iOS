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
import KakaoSDKUser

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner])
    }
    
    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

@main
struct ToucheeseMVPApp: App {
    @StateObject private var studioListViewModel = StudioListViewModel()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var studioLikeListViewModel = StudioLikeListViewModel()
    @StateObject private var studioConceptViewModel = StudioConceptViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let keychainManager = KeychainManager.shared
    private let authManager = AuthenticationManager.shared
    
    init() {
        CacheManager.configureKingfisherCache()
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ToucheeseTabView()
                .environmentObject(studioListViewModel)
                .environmentObject(navigationManager)
                .environmentObject(studioLikeListViewModel)
                .environmentObject(studioConceptViewModel)
                .preferredColorScheme(.light)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .task {
                    switch await authManager.initialCheckAuthStatus() {
                    case .notAuthenticated:
                        print("로그아웃 상태")
                    case .authenticated:
                        print("로그인 상태(토큰 갱신 성공)")
                        //                        // 예약 정보 불러오기
                        //                        await reservationListViewModel.fetchReservations()
                        //                        // 이전 예약 정보 불러오기
                        //                        await reservationListViewModel.fetchPastReservations()
                        //                        // 좋아요 표시한 스튜디오 불러오기
                        //                        AuthenticationManager.shared.failedAuthentication()
                    }
                }
        }
    }
}

//    /// FCM 토큰을 백엔드 서버에 POST 하는 메서드
//    private func postDeviceTokenRegistrationData() {
//        Task {
//            if let fcmToken = Messaging.messaging().fcmToken,
//               let memberId = authManager.memberId {
//                do {
//                    try await networkManager.performWithTokenRetry(
//                        accessToken: authManager.accessToken,
//                        refreshToken: authManager.refreshToken
//                    ) { token in
//                        let deviceTokenRegistrationRequest = DeviceTokenRegistrationRequest(
//                            memberId: memberId,
//                            deviceToken: fcmToken
//                        )
//                        try await networkManager.postDeviceTokenRegistrationData(
//                            deviceTokenRegistrationRequest: deviceTokenRegistrationRequest,
//                            accessToken: token
//                        )
//                    }
//                } catch {
//                    print("Post DeviceTokenRegistrationData failed: \(error.localizedDescription)")
//                    authManager.logout()
//                }
//            }
//        }
//    }
//}
