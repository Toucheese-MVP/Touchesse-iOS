//
//  ReservationViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import Foundation

final class ReservationViewModel: ObservableObject {
    let networkmanager = NetworkManager.shared
    let authManager = AuthenticationManager.shared
    
    let studio: Studio
    let studioDetail: StudioDetail
    let product: Product
    let productDetail: ProductDetail
    let productOptions: [ProductOption]
    let reservationDate: Date
    let totalPrice: Int
    let addPeopleCount: Int
    private(set) var isReserving: Bool = false
    
    // MARK: - 멤버 임시 데이터
    lazy var userName = authManager.memberNickname
    lazy var memberId = authManager.memberId
    
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    
    var isEmailFormat: Bool {
        userEmail.isEmailFormat
    }
    
    var isPhoneLength: Bool {
        userPhone.isPhoneLength
    }
    
    var isBottomButtonSelectable: Bool {
        if userEmail.isEmailFormat && userPhone.isPhoneLength {
            return true
        } else {
            return false
        }
    }
    
    var addpeopleTotalPriceString: String {
        guard let addPeoplePrice = productDetail.addPeoplePrice else { return "error"}
        return (addPeoplePrice * addPeopleCount).moneyStringFormat
    }
    
    // MARK: - TODO: 추후 응답값에 따라 에러처리 가능
    private(set) var reservationResponseData: ReservationResponseData? = nil
    
    // MARK: - Init
    init(
        studio: Studio,
        studioDetail: StudioDetail,
        product: Product,
        productDetail: ProductDetail,
        productOptions: [ProductOption],
        reservationDate: Date,
        totalPrice: Int,
        addPeopleCount: Int
    ) {
        self.studio = studio
        self.studioDetail = studioDetail
        self.product = product
        self.productDetail = productDetail
        self.productOptions = productOptions
        self.reservationDate = reservationDate
        self.totalPrice = totalPrice
        self.addPeopleCount = addPeopleCount
    }
    
    // MARK: - Logic
    func setIsReserving() {
        isReserving = true
    }
    
    /// 스튜디오 예약 요청을 보내는 함수
    func requestStudioReservation() async {
        guard let memberId else {
            print("requestStudioReservation - memberId is nil")
            return
        }
        
        let reservationRequestType = ReservationRequest(
            memberId: memberId,
            studioId: studio.id,
            reservationDate: reservationDate,
            productId: product.id,
            productOptions: productOptions,
            totalPrice: totalPrice,
            phoneNumber: userPhone,
            email: userEmail,
            addPeopleCnt: addPeopleCount
        )
        
        do {
            reservationResponseData = try await networkmanager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [unowned self] token in
                return try await networkmanager.postStudioReservation(
                    reservationRequest: reservationRequestType,
                    accessToken: token
                )
            }
        } catch NetworkError.unauthorized {
            print("requestStudioReservation Error: AccessToken is expired")
            await authManager.logout()
        } catch {
            print("requestStudioReservation Error: \(error.localizedDescription)")
        }
    }
}
