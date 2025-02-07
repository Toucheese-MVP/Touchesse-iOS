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
    
    // MARK: - SERVER Migration WORK
    
    /// 네트워크 FetchRequest
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
    
    func postReservationInstant(reservation: ReservationInstantRequest) async throws -> ReservationInstantEntity {
        let fetchRequest = Network.reservationInstantType(reservation)
        let result = try await performRequest(fetchRequest, decodingType: ReservationInstantEntity.self)
    
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
