//
//  Test.swift
//  ToucheeseMVPTests
//
//  Created by 강건 on 5/27/25.
//

import Testing
@testable import ToucheeseMVP

struct ProductDetailTests {
    
    // (1) 조건에 해당하는 만큼 인원을 추가합니다.
    // (2) 조건에 해당하는 만큼 인원을 감소합니다.
    //
    // *추가 인원보다 감소된 인원이 더 많아도 가격이 낮아지지 않습니다.
    // *추가 인원 가격을 제외한 기본 가격은 0원으로 설정되어 있습니다.
    // *인당 추가 가격은 10000원으로 설정했습니다.
    @Test("선택된 조건들로 단체 가격이 계산되는지/n(Increase -> Decrease)", arguments: CalculateCases.allCases)
    func test_CalculateGroupPrice(calculateCase: CalculateCases) async {
        // Given
        let viewModel = makeViewModel(plusOption: GroupOptionEntity(isPlusOpt: 1, plusOptPrice: 10000))
        
        try? await Task.sleep(for: .seconds(1))
        
        // When
        // (1)
        for _ in 0 ..< calculateCase.calculateCase.increasePeopleCnt {
            viewModel.increaseAddPeopleCount()
        }

        // (2)
        for _ in 0 ..< calculateCase.calculateCase.decreasePeopleCnt{
            viewModel.decreaseAddPeopleCount()
        }

        // Then
        #expect(viewModel.addPeopleCount == calculateCase.calculateCase.addPeopleCnt)
        #expect(viewModel.totalPrice == calculateCase.calculateCase.totalPrice)
    }
    
    
    func makeViewModel(plusOption: GroupOptionEntity? = nil) -> ProductDetailViewModel {
        let mockProductService = MockProductService()
        
        if let plusOption {
            mockProductService.plusOptionInfoStub = plusOption
        }
        
        return ProductDetailViewModel(
            studio: Studio.sample,
            studioDetails: StudioDetailEntity.sample,
            product: ProductEntity.sample,
            productService: mockProductService
        )
    }
    
    enum CalculateCases: CaseIterable {
        case result_0
        case result_30000
        case result_60000
        
        var calculateCase: (increasePeopleCnt: Int, decreasePeopleCnt: Int, addPeopleCnt: Int, totalPrice: Int) {
            switch self {
            case .result_0:
                return (2, 3, 0, 0)
            case .result_30000:
                return (5, 2, 3, 30000)
            case .result_60000:
                return (6, 0, 6, 60000)
            }
        }
    }
    
}
