//
//  VotingProgressCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation
import SwiftUI

struct VotingProgressCarousel: View {
    @StateObject private var viewModel = VotingProgressViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Voting In Progress")
                .font(TextStyles.subheading)
                .foregroundColor(.white)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    if viewModel.polls.isEmpty {
                        // Places 1 placeholder view icon
                        ForEach(0..<3, id: \.self) { _ in
                            PlaceholderVotingIconView()
                        }
                    } else {
                        ForEach(viewModel.polls) { poll in
                            VotingIconView(details: poll)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchVotingProgress()
            }
        }
    }
}


struct VotingIconView: View {
    let details: Poll
    
    var body: some View {
        VStack {
//          based on if the poll is_closed == true, etc.
            Image(systemName: details.is_closed ? "checkmark.circle.fill" : "clock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(details.is_closed ? .blue : .gray)
            Text(details.title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 80)
    }
}

// Placeholder while loading
struct PlaceholderVotingIconView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 10)
        }
        .frame(width: 80)
    }
}

// MARK: - Preview
struct VotingProgressCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VotingProgressCarousel()
            .background(AppColors.backgroundGray)
        
        // testing votingicons
        VStack(spacing: 16) {
           Text("Closed Poll")
               .font(.headline)
               .foregroundColor(.white)
           VotingIconView(details: Poll(
               poll_id: "1",
               title: "Poll Closed",
               is_closed: true,
               votes_cast: 50,
               number_of_attendees: 100,
               final_start_time: "10:00 AM",
               final_end_time: "12:00 PM"
           ))

           Text("Open Poll")
               .font(.headline)
               .foregroundColor(.white)
           VotingIconView(details: Poll(
               poll_id: "2",
               title: "Poll Open",
               is_closed: false,
               votes_cast: 30,
               number_of_attendees: 80,
               final_start_time: nil,
               final_end_time: nil
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
