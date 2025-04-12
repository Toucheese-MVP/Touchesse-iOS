//
//  ViewMaterial.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/10/24.
//

import Foundation

protocol ViewMaterial { }

//TODO: 추상화 적용하기
struct ReservationDetailViewMaterial: ViewMaterial {
//    var viewModel: any ReservationDetailViewModelProtocol
    var viewModel: ReservationDetailViewModel
    var reservation: Reservation
}
