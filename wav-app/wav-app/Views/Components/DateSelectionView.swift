//
//  DateSelectionView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/2/25.
//

import SwiftUI

struct DateSelectionView: View {
    @Binding var selectedDate: Date?
    @State private var showDatePicker = false
    let placeholder: String

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
                Button(action: {
                    withAnimation {
                        if selectedDate == nil {
                            selectedDate = Date()
                        }
                        showDatePicker.toggle()
                    }
                }) {
                    Color.clear // Invisible tappable area
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
            }
            .contentShape(Rectangle())

            if showDatePicker {
                DatePicker(
                    "Choose a date",
                    selection: Binding(
                        get: { selectedDate ?? Date() },  // Use current date if nil (for display only)
                        set: { newDate in selectedDate = newDate } // Set actual date
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .transition(.move(edge: .top).combined(with: .opacity))
                .frame(maxHeight: 400)
                .clipped()
//                .onChange(of: selectedDate) { _, _ in
//                    withAnimation {
//                        showDatePicker = false // Auto-close DatePicker after selection
//                    }
//                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showDatePicker)
    }

    // Formats date to display in the text input
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
