//
//  NewMeetingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/31/24.
//

import SwiftUI

struct NewMeetingView: View {
    @StateObject private var viewModel = NewMeetingViewModel()
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                NewMeetingStep1View(viewModel: viewModel, currentPage: $currentPage, selectedDuration: $viewModel.selectedDuration)
                    .tag(0)
                NewMeetingStep2View(viewModel: viewModel, currentPage: $currentPage, showDatePicker: $viewModel.showDatePicker)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            //custom dots for navigation at the bottom
            HStack {
                Circle()
                    .fill(currentPage == 0 ? AppColors.highlightBlue : AppColors.textGray)
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(currentPage == 1 ? AppColors.highlightBlue : AppColors.textGray)
                    .frame(width: 10, height: 10)
            }
            .padding(.bottom, 20)
        }
        .background(AppColors.backgroundGray)
    }
}

#Preview {
    NewMeetingView().environmentObject(NewMeetingViewModel())
}

