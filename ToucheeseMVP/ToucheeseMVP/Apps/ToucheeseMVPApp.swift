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

class AppDelegate: NSObject, UIApplicationDelegate { }

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    //MARK: - FCM 등록
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Foreground에서 알림 오는 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner])
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM toekn")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // 서버에 토큰 전송
                Task {
                    do {
                        try await DefaultFCMService(session: SessionManager.shared.authSession)
                            .postFCMToken(token: token)
                    } catch {
                        print("Post FCM token Error: \(error)")
                    }
                }
            }
        }
        
        // 토큰 갱신 모니터링
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
    private let fcmService = DefaultFCMService(session: SessionManager.shared.authSession)
    
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
                    }
                }
        }
    }

}
