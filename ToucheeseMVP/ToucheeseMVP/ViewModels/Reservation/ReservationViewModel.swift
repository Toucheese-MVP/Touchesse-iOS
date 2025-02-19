//
//  ReservationViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/4/25.
//

import Foundation

protocol ReservationViewModelProtocol {
    /// 즉시 예약
    func postInstantReservation() async -> Bool
}

final class ReservationViewModel: ObservableObject, ReservationViewModelProtocol {
    private let reservationService = DefaultReservationService(session: SessionManager.shared.authSession)
    private let authManager = AuthenticationManager.shared
    
    let studio: Studio
    let studioDetail: StudioDetailEntity
    let product: ProductEntity
    let productDetail: ProductDetailEntity
    let productOptions: [OptionEntity]
    let reservationDate: Date
    let totalPrice: Int
    let addPeopleCount: Int
    
    private(set) var isReserving: Bool = false

    @Published var userPhone: String = ""
    @Published private(set) var reservationList: [Reservation] = []
    
    var isPhoneLength: Bool {
        userPhone.isPhoneLength
    }
    
    var isBottomButtonSelectable: Bool {
        if userPhone.isPhoneLength {
            return true
        } else {
            return false
        }
    }
    
    init(
        studio: Studio,
        studioDetail: StudioDetailEntity,
        product: ProductEntity,
        productDetail: ProductDetailEntity,
        productOptions: [OptionEntity],
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
    
    func setIsReserving() {
        isReserving = true
    }
    
    //MARK: - Network
    
    func postInstantReservation() async -> Bool {
        guard let memberId = authManager.memberId
        else {
            print("memberid nil!")
            return false
        }
        
        var optionIds: [Int] = []
        for productOption in productOptions {
            optionIds.append(productOption.id)
        }
        
        let reservationRequestType = ReservationInstantRequest(
            productId: product.id,
            studioId: studio.id,
            memberId: memberId,
            phone: userPhone.phoneNumberString,
            totalPrice: totalPrice,
            createDate: reservationDate.toString(format: .requestYearMonthDay),
            createTime: reservationDate.toString(format: .hourMinute),
            personnel: addPeopleCount,
            addOptions: optionIds
        )
        
        do {
            let result = try await reservationService.postReservationInstant(reservation: reservationRequestType).status
            return result
           
        } catch {
            print("post fail!")
            return false
        }
    }
}
