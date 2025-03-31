//
//  NetworkError.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case unauthorized
    case decodingFailed(Error)
    case requestFailed(AFError)
    case unexpectedStatusCode(Int)
    case unknown
}

enum ImageCompressionError: Error {
    case compressionFailed
}
