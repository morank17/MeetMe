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
    
    var body: some View {
        ScrollView(.vertical) {
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
                        in: (isSelectingEarliest
                            ? Date()...Date.distantFuture  // Earliest date can be today or later
                            : (viewModel.selectedEarliestDate ?? Date())...Date.distantFuture), // Latest date must be after the earliest date
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .colorScheme(.dark)
                    .cornerRadius(10)
                    .padding()
                }
                
                if !showDatePicker {
                    Spacer().frame(height: 41)
                }
                
                Text("Pick time(s) of day")
                    .font(TextStyles.heading)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SelectionButtonsView(
                    options: ["7am-11am", "11am-3pm", "3pm-7pm", "7pm-11pm"],
                    multiSelect: true,
                    selectedValue: .constant(nil), // Not used in multi-select mode
                    selectedOptions: $viewModel.selectedTimeSlots
                )
                
                if !showDatePicker {
                    Spacer().frame(height: 140)
                }
                Button(action: {
                    viewModel.submitNewMeeting()
                }) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: 172)
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
            .padding(.top, 90)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
