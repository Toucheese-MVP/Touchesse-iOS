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
    
    let studio: TempStudio
    let studioDetail: StudioDetailEntity
    let product: ProductEntity
    let xProduct: Product = .init(id: 1, name: "", description: "", imageString: "", price: 0, reviewCount: 0)
    let productDetail: ProductDetailEntity
    let xProductDetail: ProductDetail = .init(isGroup: true, basePeopleCnt: nil, addPeoplePrice: nil, productOptions: [])
    let productOptions: [OptionEntity]
    let xProductOptions: [ProductOption] = []
    let reservationDate: Date
    let totalPrice: Int
    let addPeopleCount: Int
    private(set) var isReserving: Bool = false
    
    // MARK: - 멤버 임시 데이터
    lazy var userName = authManager.memberNickname
    lazy var memberId = authManager.memberId

    var addpeopleTotalPriceString: String {
//        guard let addPeoplePrice = productDetail.addPeoplePrice else { return "error"}
//        return (addPeoplePrice * addPeopleCount).moneyStringFormat
        
        return ""
    }
    
    // MARK: - TODO: 추후 응답값에 따라 에러처리 가능
    private(set) var reservationResponseData: ReservationResponseData? = nil
    
    // MARK: - Init
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

}
