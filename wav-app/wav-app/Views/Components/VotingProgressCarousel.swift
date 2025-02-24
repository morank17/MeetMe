//
//  VotingProgressCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation
import SwiftUI

struct VotingProgressCarousel: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    @Binding var path: [Destination]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Voting In Progress")
                .font(TextStyles.subheading)
                .foregroundColor(.white)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    if viewModel.pollPeriodMeetings.isEmpty {
                        // Places 1 placeholder view icon
                        PlaceholderVotingIconView()
                    } else {
                        ForEach(viewModel.pollPeriodMeetings) { meeting in
                            TimerMeetingView(
                                remainingSeconds: 60,
                                progress: 1.0,
                                details: meeting
                            )
                            .onTapGesture {
                                path.append(.voting(pollId: meeting.poll_id))
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPollPeriodMeetings()
            }
        }
    }
}

struct TimerMeetingView: View {
    @State var remainingSeconds: Int
    @State var progress: CGFloat
    let details: PollPeriodMeeting
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            CircularProgressView(
                progress: progress,
                timeText: String(format: "%d:%02d", remainingSeconds / 60, remainingSeconds % 60),
                hasVoted: details.vote_status
            )
            
            Text(details.title.truncated(to: 15))
                .font(.headline)
                .foregroundColor(.white)
                .opacity(details.vote_status ? 0.3 : 1.0) // Reduce opacity when voted

            
        }
        .onReceive(timer) { _ in
            guard remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            withAnimation(.linear(duration: 1)) {
                progress = CGFloat(remainingSeconds) / 125.0
            }
        }
        .padding()
    }
}

// Placeholder while loading
struct PlaceholderVotingIconView: View {
    var body: some View {
        VStack {
            ZStack{
                Text("No Polls")
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

// MARK: - Preview
struct VotingProgressCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VotingProgressCarousel(path: .constant([]))
            .background(AppColors.backgroundGray)
        
        // testing votingicons
        VStack(spacing: 16) {
            Text("Closed Poll")
               .font(.headline)
               .foregroundColor(.white)
            TimerMeetingView(remainingSeconds: 0, progress: 1.0, details: PollPeriodMeeting(
                title: "Test",
                dates_list: ["2025-02-01"],
                minimum_duration_in_minutes: 60,
                militime_ranges: [["00:00","03:00"]],
                timezone_str: "-05:00",
                max_n_victors: 10,
                join_code: "6D2-GOF",
                participants: ["laptttop"],
                vote_status: false,
                poll_id: "1"
            ))

           Text("Open Poll")
               .font(.headline)
               .foregroundColor(.white)
           TimerMeetingView(remainingSeconds: 0, progress: 1.0, details: PollPeriodMeeting(
                title: "Test",
                dates_list: ["2025-02-01"],
                minimum_duration_in_minutes: 60,
                militime_ranges: [["00:00","03:00"]],
                timezone_str: "-05:00",
                max_n_victors: 10,
                join_code: "6D2-GOF",
                participants: ["laptttop"],
                vote_status: true,
                poll_id: "1"
           ))

           Text("Placeholder View")
               .font(.headline)
               .foregroundColor(.white)
           PlaceholderVotingIconView()
       }
       .padding()
       .background(Color.black) // To improve contrast
       .previewLayout(.sizeThatFits)
    }
}
