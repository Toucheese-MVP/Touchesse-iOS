//
//  ViewFactory.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/10/24.
//

import Foundation
import SwiftUICore

struct ViewFactory {
    @ViewBuilder
    func manufactureHomeResultView(material: HomeResultViewMaterial) -> some View {
        HomeResultView(concept: material.concept)
    }
    
    @ViewBuilder
    func manufactureStudioDetailView(material: StudioDetailViewMaterial) -> some View {
        StudioDetailView(viewModel: material.viewModel)
    }
    
    @ViewBuilder
    func manufactureProductDetailView(material: ProductDetailViewMaterial) -> some View {
        ProductDetailView(productDetailViewModel: material.viewModel)
    }
    
    @ViewBuilder
    func manufactureRservationConfirmView(material: ReservationConfirmViewMaterial) -> some View {
        ReservationConfirmView(reservationViewModel: material.viewModel)
    }
    
    @ViewBuilder
    func manufactureReservationCompeteView() -> some View {
        ReservationCompleteView()
    }
}
