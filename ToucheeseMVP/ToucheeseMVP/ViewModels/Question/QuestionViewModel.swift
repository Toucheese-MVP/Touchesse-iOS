//
//  QuestionViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/17/25.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit

protocol QuestionViewModelProtocol: ObservableObject {
    /// 화면에 보여줄 앨범에서 고른 이미지
    var displaySelectedUIImages: [UIImage] { get }
    /// 앨범에서 고른 이미지
    var selectedPhotosPickerItems: [PhotosPickerItem] { get set }
    
    /// 문의하기 요청
    func postQuestion() async
    /// 문의한 목록 가져오기
    func fetchQuestions() async
}

final class QuestionViewModel: QuestionViewModelProtocol {
    private let questionService = DefaultQuestionsService(session: SessionManager.shared.authSession)

    @Published private(set) var questions: [Question] = []
    @Published private(set) var displaySelectedUIImages: [UIImage] = []
    @Published var selectedPhotosPickerItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                // 앨범에서 이미지를 고르면 화면에 보여줄 UIImage로 변환
                await convertToUIImage()
            }
        }
    }
    
    /// 문의하기 요청
    func postQuestion() async {
        var imageDatas: [Data] = []

        for image in displaySelectedUIImages {
            do {
                let resizedImage = try image.downscaledJPEGData(to: 1.0)
                imageDatas.append(resizedImage)
            } catch {
                // TODO: 이미지 압축에 실패했음을 유저에게 알려야 함
                print("이미지 압축에 실패했습니다: \(error.localizedDescription)")
            }
        }
        
        do {
            try await questionService.postQuestions(QuestionRequest(title: "Test 문의하기",
                                                                    content: "Test 문의 히히",
                                                                    imageArray: imageDatas))
        } catch {
            print("문의하기 요청 에러: \(error.localizedDescription)")
        }
    }
    
    /// 문의한 목록 가져오기
    @MainActor
    func fetchQuestions() async {
        do {
            let result = try await questionService.fetchQuestions(page: 2)
            questions.append(contentsOf: result.content)
            print("\(questions.count)")
            print("\(questions)")
        } catch {
            print("문의한 목록 불러오기 에러: \(error.localizedDescription)")
        }
    }
    
    func generateTestImage() -> Data? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        UIColor.blue.setFill() // 파란색 이미지
        UIRectFill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.jpegData(compressionQuality: 0.8) // JPEG 데이터로 변환
    }
    
    /// selectedPhotosPickerItems의 데이터를 UIImage로 변경하여 selectedUIImages에 적용하는 함수
    @MainActor
    func convertToUIImage() async {
        var images: [UIImage] = []

        for item in selectedPhotosPickerItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                do {
                    let resizedImage = try image.downscaledPNGData(to: 1.0)
                    images.append(UIImage(data: resizedImage)!)
                } catch {
                    // TODO: 이미지 압축에 실패했음을 유저에게 알려야 함
                    print("이미지 압축에 실패했습니다: \(error.localizedDescription)")
                }
        }
    }

        displaySelectedUIImages = images
    }
}
