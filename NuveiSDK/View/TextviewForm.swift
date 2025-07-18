//
//  Untitled.swift
//  NuveiSDK
//
//  Created by Jorge on 18/7/25.
//



import SwiftUI

public struct CustomTextField: View{
    
    
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    let validation: (String) -> Bool
    let errorMessage: String?
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let cornerRadius: CGFloat
    
    @State private var showError: Bool = false
    
    public init(
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false,
        validation: @escaping (String) -> Bool = { _ in true },
        errorMessage: String? = nil,
        backgroundColor: Color = .white,
        borderColor: Color = .gray,
        textColor: Color = .black,
        cornerRadius: CGFloat = 8
    ) {
        self._text = text
        self.placeholder = placeholder.localized
        self.isSecure = isSecure
        self.validation = validation
        self.errorMessage = errorMessage?.localized
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 10))
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 1))
            .padding(.horizontal)
//        VStack(alignment: .leading, spacing: 4) {
//            Group {
//                if isSecure {
//                    SecureField(placeholder, text: $text)
//                } else {
//                    TextField(placeholder, text: $text)
//                }
//            }
//            .padding()
//            .background(backgroundColor)
//            .foregroundColor(textColor)
//            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(showError ? Color.red : borderColor, lineWidth: 1)
//            )
//            .onChange(of: text, initial: false) { newValue,arg  in
//                showError = !validation(newValue)
//            }
//            
//            if showError, let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .font(.caption)
//            }
//        }
//        .padding(.horizontal)
    }
}


#if DEBUG
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(
            text: .constant(""),
            placeholder: "Card Number".localized,
            validation: { $0.count >= 16 },
            errorMessage: "Invalid",
            backgroundColor: .white,
            borderColor: .gray,
            textColor: .black
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
