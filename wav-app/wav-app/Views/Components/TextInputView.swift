//
//  TextInputView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 1/26/25.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false // For password fields
    var keyboardType: UIKeyboardType = .default
    var defaultValue: String? = nil // Optional default value

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .leading) {
                // Placeholder text
                Text(placeholder)
                    .font(TextStyles.text)
                    .foregroundColor(isFocused ? AppColors.highlightBlue : (!text.isEmpty ? Color.white : AppColors.textGray))
                    .padding(.horizontal, 6)
                    .background(isFocused || !text.isEmpty ? AppColors.backgroundGray : Color.clear) // Background highlight
                    .offset(x: 12, y: isFocused || !text.isEmpty ? -35 : 0)
                    .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                    .animation(.easeInOut(duration: 0.1), value: isFocused || !text.isEmpty)
                    .zIndex(1)

                // Input field
                if isSecure {
                    SecureField("", text: $text)
                        .focused($isFocused)
                        .padding(.vertical, 8)
                        .offset(x: 12)
                        .font(TextStyles.text)
                        .foregroundColor(AppColors.white)
                } else {
                    TextField("", text: $text)
                        .focused($isFocused)
                        .padding(.vertical, 8)
                        .offset(x: 12)
                        .font(TextStyles.text)
                        .foregroundColor(AppColors.white)
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 58)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? AppColors.highlightBlue : AppColors.white, lineWidth: 2)
            )
            .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
        .onChange(of: text) { newValue in
            withAnimation {
                isFocused = !newValue.isEmpty
            }
        }
        .onChange(of: isFocused) { newFocus in
            if newFocus && text.isEmpty, let defaultValue = defaultValue {
                text = defaultValue
            }
        }
    }
}
