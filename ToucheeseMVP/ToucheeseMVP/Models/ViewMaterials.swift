//
//  ViewMaterial.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/10/24.
//

import Foundation

protocol ViewMaterial { }

struct HomeResultViewMaterial: ViewMaterial {
    var concept: StudioConceptEntity
}

struct StudioDetailViewMaterial: ViewMaterial {
    var viewModel: StudioDetailViewModel
}

struct ProductDetailViewMaterial: ViewMaterial {
    var viewModel: ProductDetailViewModel
}

struct ReservationConfirmViewMaterial: ViewMaterial {
    var tempViewModel: TempReservationViewModel
}

//TODO: 추상화 적용하기
struct ReservationDetailViewMaterial: ViewMaterial {
//    var viewModel: any ReservationDetailViewModelProtocol
    var viewModel: TempReservationDetailViewModel
    var reservation: TempReservation
}
