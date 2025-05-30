//
//  ImageUploadViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/1/25.
//

import SwiftUI
import PhotosUI

protocol ImageUploadViewModelProtocol: ObservableObject {
    /// 앨범에서 고른 이미지
    var selectedPhotosPickerItems: [PhotosPickerItem] { get set }
    /// 화면에 보여줄 앨범에서 고른 이미지
    /*
     사용자가 이미지를 삭제할 때 동일한 사진을 selectedPhotosPickerItems에서
     삭제하기 위해 originalIndex와 함께 튜플 형태로 관리중.
     더 좋은 방법이 있으면 알려주세요!
     */
    var displaySelectedUIImageContents: [(originalIndex: Int, image: UIImage)] { get }
    /// 이미지를 불러오는 중인지 상태 값
    var isLoadingImage: Bool { get }
    /// 선택한 사진 삭제하기
    func deleteSelectedImage(originalIndex: Int) async
    /// 용량을 줄인 이미지 Data를 불러오는 함수
    func getDownSizedImageData() async -> [Data]
}

protocol ImageUploadViewModelProtocolLogic {
    /// selectedPhotosPickerItems의 데이터를 UIImage로 변경하여 selectedUIImages에 적용하는 함수
    func convertToUIImage() async
    
}


final class ImageUploadViewModel: ImageUploadViewModelProtocol, ImageUploadViewModelProtocolLogic {
    @Published private(set) var displaySelectedUIImageContents: [(originalIndex: Int, image: UIImage)] = []
    @Published private(set) var isLoadingImage: Bool = false
    
    var selectedPhotosPickerItems: [PhotosPickerItem] = [] {
        // 앨범에서 이미지를 고르면 화면에 보여줄 UIImage로 변환
        didSet {
            Task {
                await convertToUIImage()
            }
        }
    }
    
    @MainActor
    func deleteSelectedImage(originalIndex: Int) async {
        selectedPhotosPickerItems.remove(at: originalIndex)
    }
    
    func convertToUIImage() async {
        await MainActor.run {
            isLoadingImage = true
        }
        
        var result: [(originalIndex: Int, image: UIImage)] = []
        
        // 이미지 앨범에서 불러오는 작업 병렬 처리
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, item) in selectedPhotosPickerItems.enumerated() {
                group.addTask {
                    do {
                        guard let data = try await item.loadTransferable(type: Data.self),
                              let image = UIImage(data: data) else {
                            return (index, nil)
                        }
                        
                        return (index, image)
                    } catch {
                        print("이미지 처리 실패 (index: \(index)): \(error.localizedDescription)")
                        return (index, nil)
                    }
                }
            }
            
            for await (index, image) in group {
                guard let image else { continue }
                result.append((index, image))
            }
        }
        
        Task { @MainActor in
            displaySelectedUIImageContents = result.sorted(by: { $0.originalIndex < $1.originalIndex })
            isLoadingImage = false
        }
    }
    
    func getDownSizedImageData() async -> [Data] {
        var resizedImages: [Data] = []
        
        // 이미지 다운사이징 병렬 처리
        await withTaskGroup(of: Data?.self) { group in
            for content in displaySelectedUIImageContents {
                group.addTask {
                    do {
                        let resizedImage = try content.image.downscaledJPEGData(targetMB: 2.0)
                        return resizedImage
                    } catch {
                        print("이미지 압축에 실패: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            for await data in group {
                if let data {
                    resizedImages.append(data)
                }
            }
        }
        
        return resizedImages
    }
}


