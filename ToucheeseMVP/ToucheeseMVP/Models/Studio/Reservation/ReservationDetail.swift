//
//  ReservationDetail.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import Foundation

struct ReservationDetailData: Codable {
    let statusCode: Int
    let msg: String
    let data: ReservationDetail
}


struct ReservationDetail: Codable {
    let id: Int
    let studioId: Int
    let studioAddress: String
    let memberName, memberEmail, phoneNumber: String
    let productImage, productName, productOption: String
    let productPrice, totalPrice: Int
    let addPeopleCnt: Int
    let addPeoplePrice: Int
}


extension ReservationDetail {
    static let sample = ReservationDetail(
        id: 1,
        studioId: 1,
        studioAddress: "스튜디오의 주소",
        memberName: "김마루",
        memberEmail: "toucheese@naver.com",
        phoneNumber: "01011112222",
        productImage: "https://imgur.com/YJaYOeA.png",
        productName: "증명사진",
        productOption: "고화질 원본 전체:2000@보정본 추가:10000",
        productPrice: 100_000,
        totalPrice: 230_000,
        addPeopleCnt: 0,
        addPeoplePrice: 0
    )
    
    var parsedProductOptions: [ProductOption] {
        productOption
            .split(separator: "@")
            .enumerated()
            .compactMap { index, optionString in
                let components = optionString.split(separator: ":").map(String.init)
                
                guard components.count == 2, let price = Int(components[1]) else {
                    assertionFailure("Invalid product option format: \(optionString)")
                    
                    return nil
                }
                
                return ProductOption(id: index, name: components[0], price: price)
            }
    }
    
    var productImageURL: URL {
        URL(string: productImage) ?? .defaultImageURL
    }
}

