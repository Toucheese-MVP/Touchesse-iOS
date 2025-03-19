//
//  RequestImageProtocol.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/17/25.
//

import Foundation

protocol RequestWithImageProtocol {
    var imageArray: [Data] { get }
    var imageRequestName: String { get }
}
