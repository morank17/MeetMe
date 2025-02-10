//
//  SelectionButtonsView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/2/25.
//

import SwiftUI

struct SelectionButtonsView: View {
    let options: [String]
    let multiSelect: Bool
    
    @Binding var selectedValue: String?
    @Binding var selectedOptions: Set<String>

    var body: some View {
        HStack(spacing: 6) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    handleSelection(option)
                }) {
                    Text(option)
                        .font(TextStyles.selectionlabel)
                        .padding(.vertical, 15)
                        .frame(minWidth: 67, maxWidth: .infinity)
                        .frame(height: 43)
                        .lineLimit(1)
                        .background(isSelected(option) ? AppColors.highlightBlue : AppColors.white)
                        .foregroundColor(AppColors.backgroundGray)
                        .cornerRadius(10)
                }
            }
        }
//        .padding(.horizontal, 16) // 16px margin on the sides

    }
    
    private func handleSelection(_ option: String) {
        if multiSelect {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        } else {
            selectedValue = (selectedValue == option) ? nil : option
        }
    }
    
    private func isSelected(_ option: String) -> Bool {
        return multiSelect ? selectedOptions.contains(option) : selectedValue == option
    }
}
