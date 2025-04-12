//
//  ViewType.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/10/24.
//

import Foundation

enum ViewType: Hashable {
    // home
    case homeResultView(studioConcept: StudioConceptEntity)
    case studioDetailView(studio: Studio, reviewId: Int)
    case productDetailView(studio: Studio, studioDetail: StudioDetailEntity, product: ProductEntity)
    case reservationConfirmView(
        studio: Studio,
        studioDetail: StudioDetailEntity,
        product: ProductEntity,
        productDetail: ProductDetailEntity,
        productOption: [OptionEntity],
        reservationDate: Date,
        totalPrice: Int,
        addPeopleCount: Int
    )
    case reservationCompleteView
    case reviewDetailView(studio: Studio, reviewId: Int)
    
    // reservation
    case reservationDetailView
    
    // question
    case qustionDetailView(qustion: Question)
    case questionCreateView
}
