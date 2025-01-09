//
//  Reservation.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

struct ReservationData: Codable {
    let statusCode: Int
    let msg: String
    let data: [Reservation]
}


struct Reservation: Codable, Hashable, Identifiable {
    let id: Int
    let studioImage, studioName: String
    let reservationDate, reservationTime: String
    let reservationStatus: String
}


extension Reservation {
    static let sample = Reservation(
        id: 0,
        studioImage: "https://imgur.com/YJaYOeA.png",
        studioName: "시현하다-강남 오리지널",
        reservationDate: "2024-12-25",
        reservationTime: "16:00:00",
        reservationStatus: "waiting"
    )
    
    static let samples: [Reservation] = (0..<4).map { index in
        Reservation(
            id: index,
            studioImage: "https://imgur.com/YJaYOeA.png",
            studioName: "시현하다-강남 오리지널",
            reservationDate: "2024-12-25",
            reservationTime: "16:00:00",
            reservationStatus: "waiting"
        )
    }
    
    var studioProfileImageURL: URL {
        URL(string: studioImage) ?? .defaultImageURL
    }
    
    var reservationTimeString: String {
        String(reservationTime.dropLast(3))
    }
}
