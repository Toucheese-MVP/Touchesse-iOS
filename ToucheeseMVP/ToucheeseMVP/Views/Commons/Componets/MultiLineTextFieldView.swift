//
//  MultiLineTextFieldView.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/1/25.
//

import SwiftUI

struct MultiLineTextFieldView: View {
    @Binding var inputValue: String
    let placeHolder: String
    var isError: Bool = false
    var keyboardType: UIKeyboardType = .default
    var submitAction: () -> Void = { }
    
    var lineLimit = 10
    var width: CGFloat = 253
    var height: CGFloat = 20.4
    
    var body: some View {
        VStack(spacing: 0) {
            TextField(placeHolder, text: $inputValue, axis: .vertical)
                .font(Font.pretendardMedium(14))
                .foregroundStyle(.tcGray08)
                .lineLimit(lineLimit, reservesSpace: true)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(keyboardType)
                .onSubmit {
                    submitAction()
                }
                .frame(height: height * CGFloat(lineLimit))
                .padding(.leading, 16.5)
                .padding(.trailing, 4)
                .padding(.vertical, 6)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(inputValue.isEmpty ? .tcGray04 : isError ?  .tcTempError : .tcGray07, lineWidth: 1)
                }
        }
    }
}
