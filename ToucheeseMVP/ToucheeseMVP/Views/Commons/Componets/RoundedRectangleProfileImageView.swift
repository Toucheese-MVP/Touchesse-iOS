//
//  RoundedRectangleProfileImageView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/12/24.
//

import SwiftUI
import Kingfisher

struct RoundedRectangleProfileImageView: View {
    let imageString: String
    let size: CGFloat
    let cornerRadius: CGFloat
    let downsamplingSize: CGFloat
    
    var body: some View {
        if let url = URL(string: imageString) {
            KFImage(url)
                .placeholder { ProgressView() }
                .resizable()
                .downsampling(
                    size: CGSize(
                        width: downsamplingSize,
                        height: downsamplingSize
                    )
                )
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(.rect(cornerRadius: cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.tcGray03, lineWidth: 0.92)
                }
        }
    }
}
