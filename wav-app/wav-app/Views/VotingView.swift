//
//  VotingView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/2/24.
//

import SwiftUI

struct VotingView: View {
    var pollId: String
    
    @State private var selectedPollID: String? = nil
    @State private var isNavigating = false
    @StateObject var viewModel = VotingViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    
                    // Voting title
                    Text("Voting time!")
                        .font(.custom("JetBrainsMono-Regular", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    // Meeting rows with date headers and voting counts
                    ScrollView {
                        VStack(spacing: 20) {
                            if viewModel.pollOptions.isEmpty {
                                Text("Loading Poll Options...")
                                    .foregroundColor(.white)
                                    .font(.custom("JetBrainsMono-Regular", size: 18))
                            } else {
                                ForEach(viewModel.pollOptions) { pollOption in
                                    MeetingSection(pollOption: pollOption, selectedPollID: $selectedPollID)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    // Bottom Submit button
                    HStack(spacing: 20) {
                        VStack(spacing: 5) {
                            submitButton()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                Task {
                    await viewModel.loadPollOptions(for: pollId)
                }
            }
        }
    }
    
    private func submitButton() -> some View {
        Button(action: {
            if let selectedPollID = selectedPollID {
                Task {
                    let success = await viewModel.vote(for: selectedPollID)
                    if success {
                        isNavigating = true // Navigate to PollResultsView on success
                    } else {
                        print("Voting failed, try again")
                    }
                }
            }
        }) {
            Text("SUBMIT")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.blueGradient)
                .cornerRadius(10)
                .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0)
        }
        .background(
            NavigationLink(
                destination: isNavigating ? AnyView(PollResultsView(pollId: pollId)) : AnyView(EmptyView()),
                isActive: $isNavigating
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    // Updated MeetingSection view using TimeSlotView
    struct MeetingSection: View {
        var pollOption: PollOption
        @Binding var selectedPollID: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                // Display poll option's formatted date as the header
                Text(pollOption.formattedDate)
                    .font(.custom("JetBrainsMono-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.8))
                
                // Use the existing TimeSlotView for displaying the time slot and vote count
                TimeSlotView(
                    dateTime: pollOption.formattedTime,
                    votes: pollOption.number_of_votes,
                    onPress: {
                        selectedPollID = pollOption.poll_option_id
                    }
                )
            }
        }
    }
}

// Preview (if needed)
struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView(pollId: "8c4a3ad9-a0de-46c5-bfe8-cdfdad8384d7")
            .previewDevice("iPhone 12")
            .background(AppColors.backgroundGray)
    }
}
