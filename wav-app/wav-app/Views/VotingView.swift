//
//  VotingView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/2/24.
//

import SwiftUI

struct VotingView: View {
    @State private var pollOptions: [PollOption] = [] // Array to store poll options
    @State private var selectedPollID: String? = nil
    @State private var isNavigating = false

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
                            ForEach(pollOptions) { pollOption in
                                MeetingSection(pollOption: pollOption, selectedPollID: $selectedPollID)
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
                loadPollOptions()
            }
        }
    }
    
    // Fetch Poll options from the API
    private func loadPollOptions() {
        // Replace with real data fetching logic (e.g., an API call)
        // For now, use mock data:
        let mockPollData = """
        {
            "success": true,
            "response": [
                {
                    "poll_option_id": "da71c3e2-0f9f-4f8b-a9e4-a7de8b97dea1",
                    "start_time": "2024-11-20 13:00:00",
                    "end_time": "2024-11-20 14:00:00",
                    "number_of_votes": 1
                },
                {
                    "poll_option_id": "d270f234-95c7-4e33-9521-5b67fa6bbe21",
                    "start_time": "2024-11-19 12:00:00",
                    "end_time": "2024-11-19 13:00:00",
                    "number_of_votes": 2
                },
                {
                    "poll_option_id": "0c67a56c-a479-49a1-a56d-1f60feae6eed",
                    "start_time": "2024-11-22 12:30:00",
                    "end_time": "2024-11-22 13:30:00",
                    "number_of_votes": 2
                }
            ]
        }
        """
        if let data = mockPollData.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(PollOptionResponse.self, from: data)
                self.pollOptions = decodedResponse.response
            } catch {
                print("Error decoding poll options: \(error)")
            }
        }
    }
    
    // Submit button with blue gradient
    private func submitButton() -> some View {
        Button(action: {}) {
            NavigationLink(destination: PollResultsView()) {
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
        }
    }
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
        VotingView()
            .previewDevice("iPhone 12")
    }
}
