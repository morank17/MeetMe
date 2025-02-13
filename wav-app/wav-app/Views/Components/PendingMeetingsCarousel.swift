//
//  PendingMeetingsCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI
import Foundation

struct PendingMeetingsCarousel: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Waiting for People to Join")
                .font(TextStyles.subheading)
                .foregroundColor(.white)
                .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    if viewModel.pendingMeetings.isEmpty {
                        // Places 1 placeholder view icon
                        ForEach(0..<3, id: \.self) { _ in
                            PlaceholderPendingMeetingsTab()
                        }
                    } else {
                        ForEach(viewModel.pendingMeetings) { meeting in
                            PendingMeetingsTab(details: meeting)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPendingMeetings()
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
    
    var body: some View {
        ZStack {
            // Background Rectangle
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 50)
            
            Text(details.title.truncated(to: 35)) // Limits meetingName to 20 characters
                .font(TextStyles.nonboldlarge)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
            HStack {
                Spacer() // Pushes content to the right
                HStack(spacing: 8) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                    Text("x\(details.participants.count)")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 16) // Add some padding from the right edge
            }
        }
        .frame(maxWidth: .infinity)
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
        PendingMeetingsCarousel()
            .background(AppColors.backgroundGray)
    }
}
