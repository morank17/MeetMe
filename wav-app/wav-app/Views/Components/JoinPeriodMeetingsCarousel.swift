//
//  PendingMeetingsCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI
import Foundation

struct JoinPeriodMeetingsCarousel: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Waiting for People to Join")
                .font(TextStyles.subheading)
                .foregroundColor(.white)
                .padding(.leading)
            
            List {
                if viewModel.joinPeriodMeetings.isEmpty {
                    Text(
                        "No meetings"
                    )
                    .font(TextStyles.selectionlabel)
                    .foregroundColor(AppColors.white)
                    .listRowBackground(Color.clear)

                } else {
                    ForEach(viewModel.joinPeriodMeetings) { meeting in
                        PendingMeetingsTab(details: meeting, viewModel: viewModel)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(AppColors.backgroundGray)
        }
        .onAppear {
            Task {
                await viewModel.fetchJoinPeriodMeetings()
            }
        }
    }
}

/*
 var id: String { join_code }
 let dates_list: [String]
 let minimum_duration_in_minutes: Int
 let militime_ranges: [[String]]
 let timezone_str: String
 let max_n_victors: Int
 let join_code: String /* Join Code! */
 let participants: [String]
 */

struct PendingMeetingsTab: View {
    let details: JoinPeriodMeeting
    @ObservedObject var viewModel: PendingMeetingsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(details.title.truncated(to: 35)) // Limits meeting name to 35 characters
                    .font(TextStyles.nonboldlarge)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)

                Text("Participants: \(details.participants.count)")
                    .font(TextStyles.selectionlabel)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
                Task {
                    await viewModel.endJoinPeriod(joinCode: details.join_code)
                }
            }) {
                Label("End Join Period Early", systemImage: "stop.circle.fill")
            }
            .tint(AppColors.highlightBlue)
        }
    }
}


struct PlaceholderPendingMeetingsTab: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 50)

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PendingMeetingsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        JoinPeriodMeetingsCarousel()
            .background(AppColors.backgroundGray)
    }
}
