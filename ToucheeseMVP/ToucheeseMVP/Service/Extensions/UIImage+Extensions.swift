//
//  UIImage+Extensions.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/19/25.
//

import Foundation
import SwiftUI

extension UIImage {
    /// UIImage를 JPEG 타입으로 바꾸는 함수
    /// - Parameter targetMB: 목표 파일 크기(MB단위)
    func downscaledJPEGData(to targetMB: Double) throws -> Data {
        let targetSize = Int(targetMB * 1024 * 1024)
        var quality: CGFloat = 1.0
        let minQuality: CGFloat = 0.1
        
        while quality >= minQuality {
            if let jpegData = jpegData(compressionQuality: quality),
               jpegData.count <= targetSize {
                return jpegData
            }
            
            quality -= 0.1
        }
        
        throw ImageCompressionError.compressionFailed
    }
    
    /// UIImage를 PNG 타입으로 변환하여 파일 크기를 조절하는 함수
       /// - Parameter targetMB: 목표 파일 크기(MB 단위)
       /// - Returns: 목표 크기 이하의 PNG Data
       func downscaledPNGData(to targetMB: Double) throws -> Data {
           let targetSize = Int(targetMB * 1024 * 1024)

           guard let originalData = self.pngData(), originalData.count > targetSize else {
               return self.pngData() ?? Data()
           }

           var resizedImage = self
           var scale: CGFloat = 1.0

           while let resizedData = resizedImage.pngData(), resizedData.count > targetSize {
               scale *= 0.9 // 이미지 크기를 90%로 줄이면서 압축 시도
               guard let newImage = self.resized(toScale: scale) else { break }
               resizedImage = newImage
           }

           if let finalData = resizedImage.pngData(), finalData.count <= targetSize {
               return finalData
           }

           throw ImageCompressionError.compressionFailed
       }

       /// 주어진 비율로 이미지를 리사이징하는 함수
       /// - Parameter scale: 축소할 비율 (0.0 ~ 1.0)
       /// - Returns: 리사이징된 UIImage
       func resized(toScale scale: CGFloat) -> UIImage? {
           let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
           UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
           defer { UIGraphicsEndImageContext() }

           self.draw(in: CGRect(origin: .zero, size: newSize))
           return UIGraphicsGetImageFromCurrentImageContext()
       }
}
