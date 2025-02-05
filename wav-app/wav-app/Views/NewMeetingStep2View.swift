//
//  NewMeetingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/3/25.
//

import SwiftUI

struct NewMeetingStep2View: View {
    @ObservedObject var viewModel: NewMeetingViewModel
    @Binding var currentPage: Int
    

    @State private var showDatePicker = false
    @State private var isSelectingEarliest = false
    
    let timeSlots: [String: (startHour: Int, endHour: Int)] = [
        "7am-11am": (7,11),
        "11am-3pm": (11,15),
        "3pm-7pm": (15,19),
        "7pm-11pm": (19,23)
    ]

    var body: some View {
        VStack {
            Text("Give us a range to search")
                .font(TextStyles.heading)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                DateSelectionView(
                    selectedDate: $viewModel.selectedEarliestDate,
                    showDatePicker: $showDatePicker,
                    placeholder: "Earliest Date",
                    onTap: {
                        isSelectingEarliest = true
                    }
                )
                
                DateSelectionView(
                    selectedDate: $viewModel.selectedLatestDate,
                    showDatePicker: $showDatePicker,
                    placeholder: "Latest Date",
                    onTap: {
                        isSelectingEarliest = false
                    }
                )
            }
            
            if showDatePicker {
                DatePicker(
                    "Select a date",
                    selection: Binding(
                        get: { isSelectingEarliest ? (viewModel.selectedEarliestDate ?? Date()) : (viewModel.selectedLatestDate ?? Date()) },
                        set: { newDate in
                            if isSelectingEarliest {
                                viewModel.selectedEarliestDate = newDate
                            } else {
                                viewModel.selectedLatestDate = newDate
                            }
                        }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxHeight: 400)
                .clipped()
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .padding()
            }

            Text("Pick time(s) of day")
                .font(TextStyles.heading)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(["7am-11am", "11am-3pm", "3pm-7pm", "7pm-11pm"], id: \.self) { timeSlot in
                    Button(timeSlot) {
                        print("Selected time slot: \(timeSlot)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }

            Button(action: {
                viewModel.submitNewMeeting()
            }) {
                Text("Submit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .alert(isPresented: $viewModel.showSuccessPopup) {
                Alert(
                    title: Text("Success"),
                    message: Text("🎉 Meeting created successfully!"),
                    dismissButton: .default(Text("Close"))
                )
            }
        }
        .padding()
    }
}
