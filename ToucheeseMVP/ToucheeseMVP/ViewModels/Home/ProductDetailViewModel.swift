//
//  ProductDetailViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/3/24.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    // MARK: - Data
    private let productService = DefaultProductService(session: SessionManager.shared.baseSession)
    
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetailEntity
    @Published private(set) var product: ProductEntity
    
    @Published private(set) var productDetail: ProductDetailEntity = ProductDetailEntity.sample1
    
    // 예약한 날짜
    @Published private(set) var reservationDate: Date?
    
    // 총 가격
    @Published private(set) var totalPrice: Int = 0
    
    
    // 추가 인원 변수
    @Published private(set) var addPeopleCount: Int = 1 {
        didSet {
            calTotalPrice()
        }
    }
    
    @Published private(set) var reservableTime: ReservableTime? {
        didSet {
            calReservableTime()
        }
    }
    
    private(set) var businessHourAM: [ReservableTimeSlot] = []
    private(set) var businessHourPM: [ReservableTimeSlot] = []
  
    // 선택된 옵션의 ID Set
    private var selectedOptionIDArray: Set<Int> = [] {
        didSet {
            calTotalPrice()
        }
    }
    
    @Published var selectedDate: Date = Date()
    {
        didSet {
            calReservationDate()
        }
    }
    
    var isReservationDate: Bool {
        if reservationDate == nil {
            false
        } else {
            true
        }
    }
    
    // 선택된 옵션 배열
    var selectedProductOptionArray: [OptionEntity] {
        productDetail.addOptions.filter {
            selectedOptionIDArray.contains($0.id)
        }
    }
    
    // MARK: - Init
    init(studio: Studio, studioDetails: StudioDetailEntity, product: ProductEntity) {
        self.studio = studio
        self.studioDetail = studioDetails
        self.product = product
        self.totalPrice = product.price
        
        Task {
            await fetchProductDetail()
        }
    }
    
    // MARK: - Input
    func increaseAddPeopleCount() {
        addPeopleCount += 1
    }
    
    func decreaseAddPeopleCount() {
        if addPeopleCount > 1 {
            addPeopleCount -= 1
        }
    }
    
    /// 상품의 옵션을 선택/취소했을 때 동작하는 함수
    func optionChanged(isSelected: Bool, id: Int) {
        if isSelected {
            selectedOptionIDArray.insert(id)
        } else {
            selectedOptionIDArray.remove(id)
        }
    }
    
    // MARK: - Logic
    @MainActor
    /// ProductDetail 정보를 네트워크 통신을 통해 가져오는 함수
    private func fetchProductDetail() async {
        do {
            productDetail = try await productService.getProductDetail(productId: product.id)
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReservableTime(date: Date) async {
        // TODO: 예약 가능한 시간을 불러오는 로직을 적용해야 함
//        do {
//            reservableTime = try await networkManager.getReservableTime(studioId: studio.id, date: date).data
//        } catch {
//            print("Fetch ProductDetail Error: \(error.localizedDescription)")
//        }
    }
    
    /// 상품의 총 가격을 계산하는 함수
    private func calTotalPrice() {
        var totalPrice: Int = productDetail.price
        
        // 인원별 가격 추가
        totalPrice += productDetail.price * (addPeopleCount - 1)
        
        // 옵션 별 상품 가격 추가
        for option in productDetail.addOptions {
            if selectedOptionIDArray.contains(option.id) {
                totalPrice += option.price
            }
        }
        
        self.totalPrice = totalPrice
    }
    
    /// 예약 시간을 계산하는 함수
    func calReservationDate() {
        self.reservationDate = selectedDate
    }
    
    /// 예약 가능한 시간을 계산하는 함수
    func calReservableTime() {
        var amTimeSlots: [ReservableTimeSlot] = []
        var pmTimeSlots: [ReservableTimeSlot] = []
        
        guard let openingTime = reservableTime?.openingTime.toDate(dateFormat: .requestTime),
              let lastReservationTime = reservableTime?.lastReservationTime.toDate(dateFormat: .requestTime),
              let reservableTimeArray = reservableTime?.usableReservableTimeArray
        else {
            print("가드문 실패!")
            return
        }
        
        var currentTime = openingTime
        
        while currentTime <= lastReservationTime {
            let timeString = currentTime.toString(format: .hourMinute)
            let isAvailable = reservableTimeArray.contains(timeString)
            
            print("timeString == \(timeString)")
            print("reservableTimeArray == \(reservableTimeArray)")
            
            if let hour = Calendar.current.dateComponents([.hour], from: currentTime).hour {
                if hour < 12 {
                    amTimeSlots.append(ReservableTimeSlot(reservableTime: timeString, isAvailable: isAvailable))
                } else {
                    pmTimeSlots.append(ReservableTimeSlot(reservableTime: timeString, isAvailable: isAvailable))
                }
            }
            
            currentTime.addTimeInterval(3600)
        }
        
        businessHourAM = amTimeSlots
        businessHourPM = pmTimeSlots
    }
}
