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
    var viewModel: ReservationViewModel
    var tempViewModel: TempReservationViewModel
}

struct ReservationDetailViewMaterial: ViewMaterial {
    var viewModel: ReservationDetailViewModel
    var tempViewModel: TempReservationDetailViewModel
}
