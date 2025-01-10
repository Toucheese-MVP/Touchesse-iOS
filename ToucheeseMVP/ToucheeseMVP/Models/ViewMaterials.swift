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
}

struct ReservationDetailViewMaterial: ViewMaterial {
    var viewModel: ReservationDetailViewModel
}
