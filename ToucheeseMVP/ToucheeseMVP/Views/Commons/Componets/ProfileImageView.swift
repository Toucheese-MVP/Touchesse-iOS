//
//  ProfileImageView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let imageURL: URL
    let size: CGFloat
    
    var body: some View {
        KFImage(imageURL)
            .placeholder { ProgressView() }
            .resizable()
            .downsampling(size: CGSize(width: 150, height: 150))
            .fade(duration: 0.25)
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(.circle)
    }
}

#Preview {
    ProfileImageView(
        imageURL: URL(string: "https://i.imgur.com/aXwN6fF.jpeg")!,
        size: 40
    )
}
