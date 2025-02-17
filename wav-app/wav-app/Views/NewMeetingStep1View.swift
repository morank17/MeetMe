//
//  NewMeetingStep1View.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/2/25.
//

import SwiftUI

struct NewMeetingStep1View: View {
    @ObservedObject var viewModel: NewMeetingViewModel
    @Binding var currentPage: Int
    
    @Binding var selectedDuration: String?
    
    var body: some View {
        VStack {
            Text("Pick a title!")
                .font(TextStyles.heading)
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextInputView(
                text: $viewModel.title,
                placeholder: "Meeting Title"
            )
            
            Spacer().frame(height: 41)
            
            Text("How long to meet?")
                .font(TextStyles.heading)
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SelectionButtonsView(
                options: ["15 min", "30 min", "1 hr", "2 hr"],
                multiSelect: false,
                selectedValue: $selectedDuration,
                selectedOptions: .constant([])
            )
            //updates viewmodel
            .onChange(of: selectedDuration) { _, newValue in
                if let newValue = newValue {
                    switch newValue {
                    case "15 min":
                        viewModel.meetingDurationHrs = 0
                        viewModel.meetingDurationMins = 15
                    case "30 min":
                        viewModel.meetingDurationHrs = 0
                        viewModel.meetingDurationMins = 30
                    case "1 hr":
                        viewModel.meetingDurationHrs = 1
                        viewModel.meetingDurationMins = 0
                    case "2 hr":
                        viewModel.meetingDurationHrs = 2
                        viewModel.meetingDurationMins = 0
                    default:
                        break
                    }
                }
            }
            
            Spacer().frame(height: 140)
            
            Button(action: {
                withAnimation {
                    currentPage = 1
                }
            }) {
                Text("Next")
                    .padding()
                    .frame(maxWidth: 172)
                    .background(AppColors.highlightBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
        .padding(.top, 90)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
