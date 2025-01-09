//
//  ProductDetailViewModel.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/3/24.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    // MARK: - Data
    let networkManager = NetworkManager.shared
    
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail
    @Published private(set) var product: Product
    @Published private(set) var productDetail: ProductDetail = ProductDetail.sample1
    
    // 예약한 날짜
    @Published private(set) var reservationDate: Date?
    
    // 총 가격
    @Published private(set) var totalPrice: Int = 0
    
    
    // 추가 인원 변수
    @Published private(set) var addPeopleCount: Int = 0 {
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
    
    // 선택된 시간
    @Published var selectedTime: Date?
    
    // 선택된 날짜
    @Published var selectedDate: Date = Date() {
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
    var selectedProductOptionArray: [ProductOption] {
        productDetail.parsedProductOptions.filter { selectedOptionIDArray.contains($0.id) }
    }
    
    // MARK: - Init
    init(studio: Studio, studioDetails: StudioDetail, product: Product) {
        self.studio = studio
        self.studioDetail = studioDetails
        self.product = product
        
        Task {
            await fetchProductDetail()
        }
        
        calTotalPrice()
    }
    
    // MARK: - Input
    func increaseAddPeopleCount() {
        addPeopleCount += 1
    }
    
    func decreaseAddPeopleCount() {
        if addPeopleCount > 0 {
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
    
    /// 상품의 예약 시간을 선택했을 때 동작하는 함수
    func selectTime(time: String) {
        selectedTime = time.toDate(dateFormat: .hourMinute)
    }
    
    /// 상품의 예약 날짜를 선택했을 때 동작하는 함수
    func selectDate(date: Date) {
        selectedDate = date
    }
    
    // MARK: - Output
    /// 인원 추가 가격을 문자열로 리턴하는 함수
    func getAddPeoplePriceString() -> String {
        guard let addPeoplePrice = productDetail.addPeoplePrice?.moneyStringFormat else { return "" }
        return addPeoplePrice
    }
    
    // MARK: - Logic
    @MainActor
    /// ProductDetail 정보를 네트워크 통신을 통해 가져오는 함수
    private func fetchProductDetail() async {
        do {
            productDetail = try await networkManager.getProductDetailData(productID: product.id)
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReservableTime(date: Date) async {
        do {
            reservableTime = try await networkManager.getReservableTime(studioId: studio.id, date: date).data
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
    
    /// 상품의 총 가격을 계산하는 함수
    private func calTotalPrice() {
        var totalPrice: Int = 0
        
        // 상품 기본 가격 추가
        totalPrice += product.price
        
        // 단체 인원별 가격 추가
        totalPrice += (productDetail.addPeoplePrice ?? 0) * addPeopleCount
        
        // 옵션 별 상품 가격 추가
        for option in productDetail.parsedProductOptions {
            if selectedOptionIDArray.contains(option.id) {
                totalPrice += option.price
            }
        }
        
        self.totalPrice = totalPrice
    }
    
    /// 예약 시간을 계산하는 함수
    func calReservationDate() {
        guard let selectedTime else { return }
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        var reservationDate = DateComponents()
        reservationDate.year = dateComponents.year
        reservationDate.month = dateComponents.month
        reservationDate.day = dateComponents.day
        reservationDate.hour = timeComponents.hour
        reservationDate.minute = timeComponents.minute
      
        self.reservationDate = calendar.date(from: reservationDate)
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
