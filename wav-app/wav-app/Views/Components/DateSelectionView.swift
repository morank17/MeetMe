//
//  NewMeetingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/3/25.
//

import SwiftUI

struct DateSelectionView: View {
    @Binding var selectedDate: Date?
    @Binding var showDatePicker: Bool
    let placeholder: String
    let onTap: () -> Void
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack {
                TextInputView(
                    text: Binding(
                        get: { selectedDate.map { formattedDate($0) } ?? "" },
                        set: { _ in }
                    ),
                    placeholder: placeholder
                )
                .focused($isFocused)
                
                Button(action: {
                    if selectedDate == nil {
                        selectedDate = Date()
                    }
                    onTap()
                    withAnimation {
                        isFocused = true
                        showDatePicker = true
                    }
                }) {
                    Color.clear
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
            }
            .contentShape(Rectangle())
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
