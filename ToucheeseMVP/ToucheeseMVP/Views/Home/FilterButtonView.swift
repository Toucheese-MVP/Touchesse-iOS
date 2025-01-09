//
//  FilterButtonView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/14/24.
//

import SwiftUI

struct FilterButtonView: View {
    let filter: StudioFilter
    var isFiltering: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text(filter.title)
                .font(.pretendardRegular14)
            
            switch filter {
            case .region, .price:
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 11)
            case .rating:
                EmptyView()
            }
        }
        .foregroundStyle(isFiltering ? .tcPrimary06 : .tcGray08)
        .foregroundStyle(.black)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(isFiltering ? .tcPrimary01 : .clear)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isFiltering ? .tcPrimary04 : .tcGray03, lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            FilterButtonView(filter: .price, isFiltering: false)
            FilterButtonView(filter: .price, isFiltering: true)
        }
        
        HStack {
            FilterButtonView(filter: .region, isFiltering: false)
            FilterButtonView(filter: .region, isFiltering: true)
        }
        
        HStack {
            FilterButtonView(filter: .rating, isFiltering: false)
            FilterButtonView(filter: .rating, isFiltering: true)
        }
    }
}
