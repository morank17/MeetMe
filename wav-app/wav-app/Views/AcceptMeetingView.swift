//
//  AcceptMeetingView.swift
//  wav-app
//
//  Created by Romeo Myrthil on 2/16/25.
//
    
import Foundation
import SwiftUI

struct AcceptMeetingView: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    var join_code: String

    var body: some View {
        ZStack {
            AppColors.backgroundGray.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 50) {
                
                Spacer()
                
                Text("Join Meeting")
                    .font(TextStyles.heading)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .padding()
                
                if let meeting = viewModel.meetingInfo {
                    MeetingView(details: meeting, viewModel: viewModel)
                } else {
                    PlaceholderMeetingView()
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            Task { await viewModel.fetchMeetingInfo(join_code: join_code) }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MeetingView: View {
    let details: MeetingInfo
    @ObservedObject var viewModel: PendingMeetingsViewModel
//    var fetcher: CalendarFetcher
    
    var body: some View {
        VStack(spacing: 10) {
            Text(details.title)
                .font(TextStyles.heading)
                .foregroundColor(.white)
                .bold()
                .padding(.vertical)
            
            // You can use the dates_list indices if needed.
            if let indices = firstAndLastIndices(from: details.dates_list) {
                // Example: Use the first and last date to format your display.
                Text("Dates: \(details.dates_list[indices.firstIndex]) - \(details.dates_list[indices.lastIndex])")
                    .font(TextStyles.subheading)
                    .foregroundColor(.white)
                    .padding(.vertical)
            } else {
                // Fallback if no dates available.
                Text("No dates available")
                    .font(TextStyles.subheading)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            
            // Use the first participant as the "host" if available.
            if let host = details.participants.first {
                Text("Host: \(host)")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            
            Text("Meeting ID: \(details.join_code)")
                .foregroundColor(AppColors.textGray)
                .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 3)
        )
        .padding(.horizontal, 20)
        
        HStack(spacing: 20) {
            // display accept button if in meeting
            if (details.in_meeting) {
                Text("Already Joined")
                    .foregroundColor(.white)
                    .frame(width: 170, height: 75)
                    .background(Color.blue)
                    .cornerRadius(10)
            } else {
                Button(action: {
                    // Deny action
                }) {
                    Text("Deny")
                        .foregroundColor(.red)
                        .frame(width: 170, height: 75)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3))
                }
                
                Button(action: {
                    Task {
                        print("trying to join")
                        await viewModel.joinMeeting(join_code: details.join_code)
                        let fetcher = CalendarFetcher()
                        await fetcher.sendEventsToBackend(datesList: details.dates_list, timeZoneStr: details.timezone_str)
                    }
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .frame(width: 170, height: 75)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 50)
    }
}

// Placeholder while loading
struct PlaceholderMeetingView: View {
    var body: some View {
        VStack {
            ZStack{
                Text("No Meetings")
                    .font(TextStyles.boldtext)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 114, height: 114)
            }
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 114, height: 10)
        }
        .frame(width: 120)
    }
}


// This function returns a tuple with the first and last indices of dates_list,
// or nil if the list is empty.
func firstAndLastIndices(from dates_list: [String]) -> (firstIndex: Int, lastIndex: Int)? {
    guard !dates_list.isEmpty else {
        return nil
    }
    return (0, dates_list.count - 1)
}

// Preview for SwiftUI Canvas
struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeeting = MeetingInfo(
            title: "Weekly Standup",
            dates_list: ["1/27", "2/03"],
            minimum_duration_in_minutes: 60,
            militime_ranges: [["03:00","06:00"],["20:00","23:59"]],
            timezone_str: "-05:00",
            max_n_victors: 10,
            join_code: "6D2-GOF",
            participants: ["Alice", "Bob", "Charlie"],
            in_meeting: true
        )
        let mockViewModel = PendingMeetingsViewModel()
        MeetingView(details: sampleMeeting, viewModel: mockViewModel)
            .background(AppColors.backgroundGray)
            .previewLayout(.sizeThatFits)
    }
}
#Preview {
    AcceptMeetingView(join_code: "6D2-GOF")
}
