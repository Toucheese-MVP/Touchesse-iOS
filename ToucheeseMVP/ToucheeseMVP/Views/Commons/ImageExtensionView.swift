//
//  ImageExtensionView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/30/24.
//

import SwiftUI
import Kingfisher

struct ImageExtensionView: View {
    let imageURLs: [URL]
    @Binding var currentIndex: Int
    @Binding var isShowingImageExtensionView: Bool
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentIndex) {
                        ForEach(imageURLs.indices, id:\.self) { index in
                            KFImage(imageURLs[index])
                                .placeholder { ProgressView() }
                                .resizable()
                                .fade(duration: 0.25)
                                .scaledToFit()
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    HStack(spacing: 3) {
                        Text("\(currentIndex + 1)")
                            .foregroundStyle(.tcGray01)
                        Text("/ \(imageURLs.count)")
                            .foregroundStyle(.tcGray04)
                    }
                    .font(.pretendardMedium18)
                    .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .ignoresSafeArea()
            
            HStack {
                Button {
                    isShowingImageExtensionView.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.6))
                        }
                }
                .padding(.leading, 20)
                
                Spacer()
            }
        }
        .background(Color.black.opacity(0.8))
        .background(ClearBackground())
        .gesture(swipeDownToDismiss)
    }
    
    private var swipeDownToDismiss: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.height > 0 {
                    offset = gesture.translation
                }
            }
            .onEnded { _ in
                if abs(offset.height) > 100 {
                    isShowingImageExtensionView.toggle()
                } else {
                    offset = .zero
                }
            }
    }
}


fileprivate struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = ClearBackgroundView()
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) { }
}


fileprivate class ClearBackgroundView: UIView {
    
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else { return }
        
        parentView.backgroundColor = .clear
    }
    
}


#Preview {
    NavigationStack {
        StudioDetailView(
            viewModel: StudioDetailViewModel(studio: Studio.sample, tempStudioData: TempStudio.sample)
        )
    }
}
