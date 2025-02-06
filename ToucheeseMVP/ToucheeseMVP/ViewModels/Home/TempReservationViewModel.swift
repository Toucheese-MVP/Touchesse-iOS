//
//  TempReservationViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/4/25.
//

import Foundation

final class TempReservationViewModel: ObservableObject {
    let networkmanager = NetworkManager.shared
    let authManager = TempAuthenticationManager.shared
    
    let studio: TempStudio
    let studioDetail: StudioDetailEntity
    let product: ProductEntity
    let productDetail: ProductDetailEntity
    let productOptions: [OptionEntity]
    let reservationDate: Date
    let totalPrice: Int
    let addPeopleCount: Int
    private(set) var isReserving: Bool = false

    @Published var userPhone: String = ""
    
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
        studio: TempStudio,
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
    
    func requestStudioReservation() async -> Bool {
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
            totalPrice: totalPrice,
            createDate: reservationDate.toString(format: .requestYearMonthDay),
            createTime: reservationDate.toString(format: .hourMinute),
            personnel: addPeopleCount,
            addOptions: optionIds
        )
        
        do {
            try await networkmanager.postReservationInstant(reservation: reservationRequestType)
            return true
           
        } catch {
            print("post fail!")
            return false
        }
    }
    
}
