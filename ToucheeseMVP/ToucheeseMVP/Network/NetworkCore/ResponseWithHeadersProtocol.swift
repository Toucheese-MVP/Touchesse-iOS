//
//  ResponseWithHeadersProtocol.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/4/25.
//

import Foundation

protocol ResponseWithHeadersProtocol {
    var headers: [String: String]? { get set }
}
