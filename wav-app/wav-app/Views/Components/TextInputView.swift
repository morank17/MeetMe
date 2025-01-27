//
//  TextInputView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 1/26/25.
//

import SwiftUI

struct AnimatedInputField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false // For password fields
    var keyboardType: UIKeyboardType = .default
    var defaultValue: String? = nil // Optional default value

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20) // Space for placeholder animation
            
            ZStack(alignment: .leading) {
                // Placeholder text
                Text(placeholder)
                    .font(.caption)
                    .foregroundColor(isFocused ? .blue : .gray)
                    .offset(y: isFocused || !text.isEmpty ? -35 : 0)
                    .scaleEffect(isFocused || !text.isEmpty ? 1.0 : 1.2, anchor: .leading)
                    .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)

                // Input field
                if isSecure {
                    SecureField("", text: $text)
                        .focused($isFocused)
                        .padding(.vertical, 8)
                        .keyboardType(keyboardType)
                } else {
                    TextField("", text: $text)
                        .focused($isFocused)
                        .padding(.vertical, 8)
                        .keyboardType(keyboardType)
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .onChange(of: isFocused) { newFocus in
            if newFocus && text.isEmpty, let defaultValue = defaultValue {
                text = defaultValue
            }
        }
    }
}


struct AnimatedInputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnimatedInputField(text: .constant(""), placeholder: "Username", defaultValue: "Nick")
                .padding()
            AnimatedInputField(text: .constant(""), placeholder: "Password", isSecure: true)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
