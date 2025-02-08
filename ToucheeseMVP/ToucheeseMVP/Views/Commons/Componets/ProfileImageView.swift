//
//  ProfileImageView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let imageString: String
    let size: CGFloat
    
    var body: some View {
        if let url = URL(string: imageString) {
            KFImage(url)
                .placeholder { ProgressView() }
                .resizable()
                .downsampling(size: CGSize(width: 150, height: 150))
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(.circle)
        }
    }
}
