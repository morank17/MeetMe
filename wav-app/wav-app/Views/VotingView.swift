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
                Color.black.edgesIgnoringSafeArea(.all) // Background color set to black
                
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
                    
                    // Label above Submit button
                    
                    // Bottom buttons
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
                viewModel.loadPollOptions(for: pollId)
            }
        }
    }
    
    private func submitButton() -> some View {
        Button(action: {
//            if let selectedPollID = selectedPollID {
//                viewModel.vote(for: selectedPollID) { success in
//                    if success {
//                        isNavigating = true // Update state to navigate to PollResultsView
//                    } else {
//                        print("Voting failed, try again")
//                    }
//                }
//            }
        }) {
            Text("SUBMIT")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    AppColors.blueGradient
                )
                .cornerRadius(10)
                .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
        }
        .background(
            NavigationLink(
                destination: isNavigating ? AnyView(PollResultsView(pollId: pollId)) : AnyView(EmptyView()),
                isActive: $isNavigating // Binding isActive to isNavigating
            ) {
                EmptyView()
            }
                .hidden() // Keep NavigationLink hidden so it doesn't affect layout
        )
    }
    
    // View for each meeting section with a header date and list of time slots
    struct MeetingSection: View {
        var pollOption: PollOption
        @Binding var selectedPollID: String?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                // Display poll option start time as the header
                Text(pollOption.formattedDate)
                    .font(.custom("JetBrainsMono-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.8))
                
                // Display the time slot and votes for this poll option
                timeSlotView(pollOption: pollOption)
            }
        }
        
        
        // Individual time slot with vote indicator
        private func timeSlotView(pollOption: PollOption) -> some View {
            Button(action: {
                selectedPollID = pollOption.poll_option_id
            }) {
                HStack {
                    Text(pollOption.formattedTime)
                        .font(.custom("JetBrainsMono-Regular", size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(pollOption.number_of_votes)")
                        .font(.custom("JetBrainsMono-Regular", size: 14))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.cyan.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8) // Set width to 80% of screen
                .background(
                    selectedPollID == pollOption.poll_option_id ? AppColors.blueGradient : AppColors.gradientTypedBlack
                )
                .cornerRadius(20) // Rounded corners
                .shadow(color: Color.cyan.opacity(0.5), radius: 5, x: 0, y: 0) // Glow effect for row
            }
        }
    }
    
    // Preview
    struct VotingView_Previews: PreviewProvider {
        static var previews: some View {
            VotingView(pollId: "f4685efe-690a-4c8c-86d0-60dedfa3f7b9")
                .previewDevice("iPhone 12")
        }
    }
}
