//
//  TextFieldView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/14/24.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var inputValue: String
    let placeHolder: String
    var isError: Bool = false
    var keyboardType: UIKeyboardType = .default
    var submitAction: () -> Void = { }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(inputValue.isEmpty ? .tcGray04 : isError ?  .tcTempError : .tcGray07, lineWidth: 1)
                .frame(width: 253, height: 42)
                .overlay {
                    HStack {
                        TextField("", text: $inputValue, prompt: Text(placeHolder).foregroundColor(.tcGray04))
                            .font(.pretendardMedium14)
                            .foregroundStyle(.tcGray08)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(keyboardType)
                            .onSubmit {
                                submitAction()
                            }
                            .lineLimit(1)
                            .padding(.leading, 16.5)
                            .padding(.trailing, inputValue.isEmpty ? 16.5 : 4)
                            .padding(.vertical, 5)
                        
                        if !inputValue.isEmpty {
                            Spacer()
                            
                            Button {
                                inputValue = ""
                            } label: {
                                Image(.tcDelete)
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.tcGray04)
                            }
                            .padding(.trailing, 16.5)
                        }
                    }
                }
        }
    }
}

#Preview {
    TextFieldView(
        inputValue: .constant(""),
        placeHolder: "이메일을 입력해주세요",
        isError: false
    )
}
