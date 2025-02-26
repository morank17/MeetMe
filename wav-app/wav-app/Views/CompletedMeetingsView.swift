//
//  CompletedMeetingsView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/24/25.
//

import SwiftUI

struct CompletedMeetingsView: View {
    @StateObject private var viewModel = CompletedMeetingsViewModel()
    
    
    var body: some View {
        VStack {
            Text("Completed Meetings")
                .font(TextStyles.heading)
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
            List {
                ForEach(viewModel.completedMeetings.filter { !$0.archive }) { meeting in
                    CompletedMeetingsTab(details: meeting, viewModel: viewModel)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .background(AppColors.backgroundGray)

        }
        .padding(.top, 90)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(AppColors.backgroundGray)
        .onAppear {
            Task {
                await viewModel.fetchCompletedMeetings()
            }
        }
    }
}

struct CompletedMeetingsTab: View {
    let details: CompletedMeeting
    @ObservedObject var viewModel: CompletedMeetingsViewModel
    
    var hasWinningTime: Bool {
        return details.winning_start_datetime != nil && details.winning_end_datetime != nil
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(details.title.truncated(to: 35)) // Limits meetingName to 35 characters
                    .font(TextStyles.nonboldlarge)
                    .foregroundColor(AppColors.white)
                    .padding(.bottom, 4)

                Text(
                    hasWinningTime ?
                    formatDateRange(start: details.winning_start_datetime!, end: details.winning_end_datetime!) :
                    "No winning time"
                )
                .font(TextStyles.selectionlabel)
                .foregroundColor(AppColors.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
                viewModel.declineMeeting()
            }) {
                Label("Decline", systemImage: "minus")
            }
            .tint(.red)

            Button(action: {
                if hasWinningTime {
                    viewModel.acceptMeeting()
                }
            }) {
                Label("Accept", systemImage: "calendar.badge.plus")
            }
            .tint(hasWinningTime ? .green : .gray)
        }
    }

    private func formatDateRange(start: String, end: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        guard let startDate = dateFormatter.date(from: start),
              let endDate = dateFormatter.date(from: end) else {
            return "Invalid date"
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd/yy h:mm a"

        return "\(displayFormatter.string(from: startDate)) - \(displayFormatter.string(from: endDate))"
    }
}
