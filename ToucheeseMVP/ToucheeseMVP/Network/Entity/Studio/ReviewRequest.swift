//
//  ReviewRequest.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/13/25.
//

import Foundation

struct ReviewRequest: RequestWithImageProtocol {
    let studioID: Int
    let productID: Int
    let content: String
    let rating: Int
    
    let imageArray: [Data]
    let imageRequestName = "uploadFiles"
}
