//
//  ImageCarouselView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ImageCarouselView: View {
    let imageStrings: [String]
    @Binding var carouselIndex: Int
    @Binding var isShowingImageExtensionView: Bool
    
    var width: CGFloat = CGFloat.screenWidth
    var height: CGFloat = .infinity
    
    var body: some View {
        TabView(selection: $carouselIndex) {
            ForEach(imageStrings.indices, id:\.self) { index in
                if let imageURL = URL(string: imageStrings[index]) {
                    KFImage(imageURL)
                        .placeholder { ProgressView() }
                        .resizable()
                        .fade(duration: 0.25)
                        .scaledToFill()
                        .onTapGesture {
                            isShowingImageExtensionView.toggle()
                        }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: width, height: height)
        .overlay(alignment: .bottomTrailing) {
            HStack {
                Spacer()
                HStack(spacing: 3) {
                    Text("\(carouselIndex + 1)")
                        .foregroundStyle(.tcGray01)
                    Text("/ \(imageStrings.count)")
                        .foregroundStyle(.tcGray04)
                }
                .font(.pretendardMedium14)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.black.opacity(0.5))
                }
                .padding()
            }
        }
    }
}
