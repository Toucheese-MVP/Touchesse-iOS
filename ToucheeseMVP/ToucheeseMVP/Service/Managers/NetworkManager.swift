//
//  NetworkManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum NetworkError: Error {
    case unauthorized
    case decodingFailed(Error)
    case requestFailed(AFError)
    case unexpectedStatusCode(Int)
    case unknown
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init () { }
    
    private func performRequest<T: Decodable>(
        _ fetchRequest: Network,
        decodingType: T.Type
    ) async throws -> T {
        let url = fetchRequest.baseURL + fetchRequest.path
        print("\(url)")
        
        let request = AF.request(
            url,
            method: fetchRequest.method,
            parameters: fetchRequest.parameters,
            encoding: fetchRequest.encoding,
            headers: fetchRequest.headers
        )
        
        let response = await request.validate()
            .serializingData()
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unknown
        }
                
        switch statusCode {
        case 200...299:
            switch response.result {
            case .success(let data):
                print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    // ResponseWithHeadersProtocol 프로토콜을 준수하는 경우 headers 추가해서 리턴
                    if var responseWithHeaders = decodedData as? ResponseWithHeadersProtocol {
                        responseWithHeaders.headers = response.response?.allHeaderFields as? [String: String]
                        return responseWithHeaders as! T
                    }
                    
                    return decodedData
                } catch {
                    print("\(decodingType) 디코딩 실패: \(error.localizedDescription)")
                    throw NetworkError.decodingFailed(error)
                }
            case .failure(let error):
                print("\(decodingType) 네트워크 요청 실패: \(error.localizedDescription)")
                throw NetworkError.requestFailed(error)
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.unexpectedStatusCode(statusCode)
        }
    }
    
    /// Header에 Access Token을 보내야 하는 API 통신에 해당 메서드를 사용
    func performWithTokenRetry<T>(
        accessToken: String?,
        refreshToken: String?,
        operation: @escaping (String) async throws -> T
    ) async throws -> T {
        guard let accessToken, let refreshToken else {
            throw NetworkError.unauthorized
        }
        
        do {
            return try await operation(accessToken)
        } catch NetworkError.unauthorized {
            let refreshRequest = RefreshAccessTokenRequest(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            let newTokenData = try await postRefreshAccessToken(
                refreshRequest
            )
            
            KeychainManager.shared.update(
                token: newTokenData.accessToken,
                forAccount: .accessToken
            )
            KeychainManager.shared.update(
                token: newTokenData.refreshToken,
                forAccount: .refreshToken
            )
            
            return try await operation(newTokenData.accessToken)
        }
    }

    
    /// 스튜디오 리스트 데이터를 요청하는 함수
    /// - Parameter concept: 스튜디오 컨셉
    /// - Parameter isHighRating: 점수 필터 (True에 적용 O, False와 Nil일 때 적용 X)
    /// - Parameter regionArray: 지역 필터 (배열에 해당하는 Region 타입을 담아서 사용)
    /// - Parameter isLowpricing: 가격 필터 (True == 낮은 가격순, False == 높은 가격순, Nil == 적용 X)
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 Nil일 때 기본값 1 적용)
    func getStudioListDatas(
        concept: StudioConcept,
        isHighRating: Bool? = nil,
        regionArray: [StudioRegion]? = nil,
        price: StudioPrice? = nil,
        page: Int? = nil
    ) async throws -> (list: [Studio], count: Int) {
        let fetchRequest = Network.studioListRequest(
            concept: concept,
            isHighRating: isHighRating,
            regionArray: regionArray,
            price: price,
            page: page
        )
        let studioData: StudioData = try await performRequest(
            fetchRequest,
            decodingType: StudioData.self
        )
        
        return (studioData.data.content, studioData.data.totalElementsCount)
    }
    
    /// 스튜디오의 자세한 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디
    func getStudioDetailData(studioID id: Int) async throws -> StudioDetail {
        let fetchRequest = Network.studioDetailRequest(id: id)
        let studioDetailData: StudioDetailData = try await performRequest(
            fetchRequest,
            decodingType: StudioDetailData.self
        )
        
        return studioDetailData.data
    }
    
    
    /// 단일 스튜디오 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오 데이터를 불러온다.
    func getStudioData(studioID id: Int) async throws -> Studio {
        let fetchRequest = Network.studioRequest(id: id)
        let singleStudioData: SingleStudioData = try await performRequest(
            fetchRequest,
            decodingType: SingleStudioData.self
        )
        
        return singleStudioData.data
    }
    
    /// 리뷰 리스트를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오의 리뷰 리스트를 불러온다.
    /// - Parameter productID: 상품의 아이디. 아이디에 해당하는 상품의 리뷰 리스트를 불러온다.
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 nil일 때 기본값 1 적용)
    func getReviewListDatas(
        studioID: Int,
        productID: Int? = nil,
        page: Int? = nil
    ) async throws -> [Review] {
        let fetchRequest = Network.reviewListRequest(
            studioID: studioID,
            productID: productID,
            page: page
        )
        let reviewData: ReviewData = try await performRequest(fetchRequest, decodingType: ReviewData.self)
        
        return reviewData.content
    }
    
    /// 상품의 자세한 데이터를 요청하는 함수
    /// - Parameter productID: 상품의 아이디. 아이디에 해당하는 상품의 자세한 데이터를 불러온다.
    func getProductDetailData(productID id: Int) async throws -> ProductDetail {
        let fetchRequest = Network.productDetailRequest(id: id)
        let productDetailData: ProductDetailData = try await performRequest(
            fetchRequest,
            decodingType: ProductDetailData.self
        )
        return productDetailData.data
    }
    
    /// 리뷰의 자세한 데이터를 요청하는 함수
    /// - Parameter studioID: 스튜디오 아이디. 아이디에 해당하는 스튜디오를 불러온다.
    /// - Parameter reviewID: 리뷰의 아이디. 아이디에 해당하는 리뷰의 자세한 데이터를 불러온다.
    func getReviewDetailData(
        studioID: Int,
        reviewID: Int
    ) async throws -> ReviewDetail {
        let fetchRequest = Network.reviewDetailRequest(
            studioID: studioID,
            reviewID: reviewID
        )
        let reviewDetailData = try await performRequest(fetchRequest, decodingType: ReviewDetailData.self)
        
        return reviewDetailData.data
    }
    
    /// 스튜디오에 예약을 요청하는 함수
    /// - Parameter ReservationRequestType: 예약에 필요한 정보를 담은 구조체
    func postStudioReservation(
        reservationRequest: ReservationRequest,
        accessToken: String
    ) async throws -> ReservationResponseData {
        let fetchRequest = Network.studioReservationRequest(
            reservationRequest,
            accessToken: accessToken
        )
        
        let reservationResponseData = try await performRequest(
            fetchRequest,
            decodingType: ReservationResponseData.self
        )
        
        return reservationResponseData
    }
    
    /// 특정 회원의 예약 리스트를 요청하는 함수
    /// - Parameter memberID: 회원의 아이디. 아이디에 해당하는 회원의 예약 리스트를 불러온다.
    /// - Parameter isPast: true 값이면 예약 대기, 예약 확정 리스트를 불러오고, false 값이면 예약 완료, 예약 취소 리스트를 불러온다.
    func getReservationListDatas(
        accessToken: String,
        memberID: Int,
        isPast: Bool = false
    ) async throws -> [Reservation] {
        let fetchRequest = Network.reservationListRequest(
            accessToken: accessToken,
            memberID: memberID,
            isPast: isPast
        )
        let reservationData = try await performRequest(
            fetchRequest,
            decodingType: ReservationData.self
        )
        
        return reservationData.data
    }
    
    /// 특정 예약의 자세한 데이터를 요청하는 함수
    /// - Parameter reservationID: 예약 아이디. 아이디에 해당하는 예약의 자세한 데이터를 불러온다.
    func getReservationDetailData(
        reservationID id: Int
    ) async throws -> ReservationDetail {
        let fetchRequest = Network.reservationDetailRequest(id: id)
        let reservationDetailData = try await performRequest(
            fetchRequest,
            decodingType: ReservationDetailData.self
        )
        
        return reservationDetailData.data
    }
    
    /// 특정 맴버의 스튜디오 예약을 취소하는 함수
    /// - Parameter reservationID: 예약 아이디. 아이디에 해당하는 예약을 취소한다.
    /// - Parameter memberID: 회원 아이디. 아이디에 해당하는 회원의 예약 중 예약 아이디에 해당하는 예약을 취소한다.
    @discardableResult
    func deleteReservationData(
        reservationID: Int,
        memberID: Int,
        accessToken: String
    ) async throws -> ReservationCancelResponseData {
        let fetchRequest = Network.reservationCancelRequest(
            reservationID: reservationID,
            memberID: memberID,
            accessToken: accessToken
        )
        let reservationCancelResponseData = try await performRequest(fetchRequest, decodingType: ReservationCancelResponseData.self)
        
        return reservationCancelResponseData
    }
    
    /// Push Provider에게 Device Token을 등록하는 함수
    /// - Parameter deviceTokenRegistrationRequest: Device Token 등록에 필요한 정보를 담은 구조체. 구조체의 속성으로 memberId(Int)와 deviceToken(String)이 필요하다.
    @discardableResult
    func postDeviceTokenRegistrationData(
        deviceTokenRegistrationRequest: DeviceTokenRegistrationRequest,
        accessToken: String
    ) async throws -> DeviceTokenRegistrationResponse? {
        let fetchRequest = Network.deviceTokenRegistrationRequest(
            deviceTokenRegistrationRequest,
            accessToken: accessToken
        )
        let deviceTokenRegistrationResponseData = try await performRequest(
            fetchRequest,
            decodingType: DeviceTokenRegistrationResponseData.self
        )
        
        return deviceTokenRegistrationResponseData.data
    }
    
    /// 특정 날짜의 예약 가능한 시간을 조회하는 함수
    /// - Parameter studioId: 조회하려는 스튜디오의 ID 값
    /// - Parameter date: 조회하려는 날짜 값 (yyyy-MM-dd) 형식
    func getReservableTime(
        studioId: Int,
        date: Date
    ) async throws -> ReservableTimeData {
        let fetchRequest = Network.reservableTimeRequest(
            studioId: studioId,
            date: date
        )
        let reservableTimeData = try await performRequest(
            fetchRequest,
            decodingType: ReservableTimeData.self
        )
        
        return reservableTimeData
    }
    
    
    /// 서버에 소셜 로그인 정보(ID)를 보내는 함수
    /// - Parameter socialID: 각 소셜 로그인 정보의 고유 ID 값
    /// - Parameter socialType: 소셜 타입(KAKAO, APPLE)
    func postSocialId(
        socialID: String,
        socialType: SocialType
    ) async throws -> LoginResponseData {
        let fetchRequest = Network.sendSocialIDRequest(
            socialID: socialID,
            socialType: socialType
        )
        
        let loginResponseData = try await performRequest(
            fetchRequest,
            decodingType: LoginResponseData.self
        )
        
        return loginResponseData
    }
    
    /// Access Token을 갱신을 서버에 요청하기 위해 사용하는 메서드
    func postRefreshAccessToken(
        _ refreshAccessTokenRequest: RefreshAccessTokenRequest
    ) async throws -> RefreshAccessTokenResponse {
        let fetchRequest = Network.refreshAccessTokenRequest(
            refreshAccessTokenRequest
        )
        let refreshTokenResponseData = try await performRequest(
            fetchRequest,
            decodingType: RefreshAccessTokenResponseData.self
        )
        
        return refreshTokenResponseData.data
    }
    
    /// 앱을 처음 시작할 때 서버에서 다음의 정보를 가져오기 위해 사용하는 메서드
    /// - Access Token
    /// - Member ID
    /// - Member Nickname
    func postAppOpen(
        _ appOpenDataRequest: AppOpenRequest
    ) async throws -> AppOpenResponse {
        let fetchRequest = Network.appOpenRequest(
            appOpenDataRequest
        )
        let appOpenResponseData = try await performRequest(
            fetchRequest,
            decodingType: AppOpenResponseData.self
        )
        
        return appOpenResponseData.data
    }
    
    /// 서버에 로그아웃 요청을 보내는 메서드
    @discardableResult
    func postLogout(accessToken: String) async throws -> LogoutResponseData {
        let fetchRequest = Network.logoutRequest(
            accessToken: accessToken
        )
        let logoutResponseData = try await performRequest(
            fetchRequest,
            decodingType: LogoutResponseData.self
        )
        
        return logoutResponseData
    }
    
    // MARK: - 추후 ViewModel에서 아래 함수로 사용
    /*
    func logout() async {
        guard authManager.authStatus == .authenticated else { return }
        
        do {
            _ = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                try await networkManager.postLogout(accessToken: token)
            }
            
            authManager.logout()
        } catch NetworkError.unauthorized {
            print("Logout Error: Refresh Token Expired.")
            authManager.logout()
        } catch {
            print("Logout Error: \(error.localizedDescription)")
        }
    }
     */
    
    /// 서버에 회원탈퇴 요청을 보내는 메서드
    @discardableResult
    func postWithdrawal(accessToken: String) async throws -> WithdrawalResponseData {
        let fetchRequest = Network.withdrawalRequest(
            accessToken: accessToken
        )
        let withdrawalResponseData = try await performRequest(
            fetchRequest,
            decodingType: WithdrawalResponseData.self
        )
        
        return withdrawalResponseData
    }
    
    // MARK: - 추후 ViewModel에서 아래 함수로 사용
    /*
    func withdrawal() async {
        guard authManager.authStatus == .authenticated else { return }
        
        do {
            _ = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                try await networkManager.postWithdrawal(accessToken: token)
            }
            
            authManager.withdrawal()
        } catch NetworkError.unauthorized {
            print("Withdrawal Error: Refresh Token Expired.")
            authManager.withdrawal()
        } catch {
            print("Withdrawal Error: \(error.localizedDescription)")
        }
    }
     */
    
    /// 서버에 회원의 닉네임 변경을 요청하는 메서드
    @discardableResult
    func putNicknameChange(
        _ nicknameChangeRequest: NicknameChangeRequest
    ) async throws -> NicknameChangeResponseData {
        let fetchRequest = Network.nicknameChangeRequest(
            nicknameChangeRequest
        )
        let nicknameChangeResponseData = try await performRequest(
            fetchRequest,
            decodingType: NicknameChangeResponseData.self
        )
        
        return nicknameChangeResponseData
    }
    
    // MARK: - 추후 ViewModel에서 아래 함수로 사용, 서버 문제로 아직 해당 메서드 테스트가 안되어 있음
    /*
    func changeNickname(newName: String) async {
        guard authManager.authStatus == .authenticated else { return }
        
        do {
            _ = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [self] token in
                if let memberId = authManager.memberId {
                    let nicknameChangeRequest = NicknameChangeRequest(
                        accessToken: token,
                        memberId: memberId,
                        newName: newName
                    )
                    try await networkManager.putNicknameChange(nicknameChangeRequest)
                } else {
                    print("Nickname Change Error: memberID is nil")
                    authManager.logout()
                }
            }
            
            authManager.logout()
        } catch NetworkError.unauthorized {
            print("Nickname Change Error: Refresh Token Expired.")
            authManager.logout()
        } catch {
            print("Nickname Change Error: \(error.localizedDescription)")
        }
    }
     */
    
    /// 서버에 사용자가 찜한 스튜디오를 등록하는 메서드
    @discardableResult
    func postStudioLike(
        _ studioLikeRelationRequest: StudioLikeRelationRequest
    ) async throws -> StudioLikeRelationResponseData {
        let fetchRequest = Network.studioLikeRequest(
            studioLikeRelationRequest
        )
        let studioLikeRelationResponseData = try await performRequest(
            fetchRequest,
            decodingType: StudioLikeRelationResponseData.self
        )
        
        return studioLikeRelationResponseData
    }
    
    /// 서버에 사용자가 찜한 스튜디오를 취소하는 메서드
    @discardableResult
    func deleteStudioLike(
        _ studioLikeRelationRequest: StudioLikeRelationRequest
    ) async throws -> StudioLikeRelationResponseData {
        let fetchRequest = Network.studioLikeCancelRequest(
            studioLikeRelationRequest
        )
        let studioLikeRelationResponseData = try await performRequest(
            fetchRequest,
            decodingType: StudioLikeRelationResponseData.self
        )
        
        return studioLikeRelationResponseData
    }
    
    /// 서버로부터 사용자가 찜한 스튜디오 목록을 요청하는 메서드
    func getStudioLikeList(
        accessToken: String,
        memberId: Int
    ) async throws -> [Studio] {
        let fetchRequest = Network.studioLikeListRequest(
            accsessToken: accessToken,
            memberID: memberId
        )
        let studioLikeListResponseData = try await performRequest(
            fetchRequest,
            decodingType: StudioLikeListResponseData.self
        )
        
        return studioLikeListResponseData.data
    }
    
    
    // MARK: - SERVER Migration WORK
    func getStudioConcept() async throws -> [StudioConceptEntity] {
        let fetchRequest = Network.studioConceptType
        
        let studioConceptArray = try await performRequest(
            fetchRequest,
            decodingType: [StudioConceptEntity].self
        )
        
        return studioConceptArray
    }
    
    func getConceptedStudioList(conceptedStudioRequest: ConceptedStudioRequest) async throws -> StudioEntity {
        let fetchRequest = Network.conceptedStudioListType(conceptedStudioRequest)
        
        let studioEntity = try await performRequest(
            fetchRequest,
            decodingType: StudioEntity.self
        )
        
        return studioEntity
    }
    
    @MainActor
    func getStudioCalendar(studioId: Int, yearMonth: String?) async throws -> [StudioCalendarEntity] {
        let fetchRequest = Network.studioCalendarType(studioID: studioId, yearMonth: yearMonth)
        
        let entity = try await performRequest(fetchRequest, decodingType: [StudioCalendarEntity].self)
        
        return entity
    }
    
    func getStudioDetail(studioID: Int) async throws -> StudioDetailEntity {
        let fetchRequest = Network.studioDetailType(studioID: studioID)
        
        let studioDetailEntity = try await performRequest(
            fetchRequest,
            decodingType: StudioDetailEntity.self
        )
        
        return studioDetailEntity
    }
    
    func getProductDetail(productId: Int) async throws -> ProductDetailEntity {
        let fetchRequest = Network.productDetailType(productId: productId)
        let result = try await performRequest(fetchRequest, decodingType: ProductDetailEntity.self)
        print("get product api call!!!")
        return result
    }
    
    // 카카오 로그인 Wrapping
    // @MainActor
    func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            // 토큰이나 에러를 처리하는 핸들러
            let resultHandler: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let oauthToken = oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
            
            // 카카오톡 앱으로 로그인이 가능한 경우
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: resultHandler)
            } else {
                // 웹으로 로그인 해야하는 경우
                UserApi.shared.loginWithKakaoAccount(completion: resultHandler)
            }
        }
    }
    
    // 카카오 사용자 정보 가져오기 Wrapping
    func fetchKakaoUserInfo() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                }
            }
        }
    }
    
    /// 카카오 유저 정보를 서버에 전송
    func postKakaoUserInfoToServer(_ kakaoLoginRequest: KakaoLoginRequest) async throws -> SocialLoginResponse {
        let fetchRequest = Network.kakaoLoginType(kakaoLoginRequest)
        
        let response = try await performRequest(
            fetchRequest,
            decodingType: SocialLoginResponse.self
        )
                
        return response
    }
    
    /// 애플 유저 정보를 서버에 전송
    func postAppleUserInfoToServer(_ appleLoginRequest: AppleLoginRequest) async throws -> SocialLoginResponse {
        let fetchRequest = Network.appleLoginType(appleLoginRequest)
        
        let response = try await performRequest(
            fetchRequest,
            decodingType: SocialLoginResponse.self
        )
                
        return response
    }
    
    /// 토큰 재발행
    func reissueToken(_ reissueTokenRequest: ReissueTokenRequest) async throws -> ReissueTokenResponse {
        let fetchRequest = Network.reissueToken(reissueTokenRequest)
        let response = try await performRequest(fetchRequest,
                                                decodingType: ReissueTokenResponse.self)

        return response
    }
}
