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
    @StateObject private var studioConceptViewModel = StudioConceptViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let keychainManager = KeychainManager.shared
    private let networkManager = NetworkManager.shared
    private let authManager = AuthenticationManager.shared
    private let tempAuthManager = TempAuthenticationManager.shared
    
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
                .environmentObject(studioConceptViewModel)
                .preferredColorScheme(.light)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .task {
                    switch await tempAuthManager.initialCheckAuthStatus() {
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
