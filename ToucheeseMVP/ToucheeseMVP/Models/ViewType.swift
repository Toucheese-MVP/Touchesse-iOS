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
    case studioDetailView(studio: Studio, studioId: Int, reviewId: Int)
    case productDetailView
    case reservationConfirmView
    case reservationCompleteView
    case reviewDetailView
    
    // reservation
    case reservationDetailView
    
    // question
    case qustionDetailView(qustion: Question)
    case questionCreateView
}
