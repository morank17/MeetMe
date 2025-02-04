//
//  NewMeetingStep2View.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/2/25.
//

import SwiftUI

struct NewMeetingStep2View: View {
    @ObservedObject var viewModel: NewMeetingViewModel
    @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            Text("Give us a range to search")
                .font(TextStyles.heading)
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                DateSelectionView(selectedDate: $viewModel.selectedEarliestDate, placeholder: "Earliest Date")
                DateSelectionView(selectedDate: $viewModel.selectedLatestDate, placeholder: "Latest Date")
            }
            
            Text("Pick time(s) of day")
                .font(.headline)
            
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
