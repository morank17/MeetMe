//
//  VotingView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/2/24.
//

import SwiftUI

struct VotingView: View {
    @State private var selectedMeetingID: UUID? = nil
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
                    
                    // Meeting rows with date headers and voting counts
                    ScrollView {
                        VStack(spacing: 20) {
                            MeetingSection(date: "Monday 10/14", times: [
                                MeetingTimeSlot(time: "3:00 PM - 4:00 PM", votes: 2),
                                MeetingTimeSlot(time: "6:00 PM - 7:00 PM", votes: 4)
                            ], selectedMeetingID: $selectedMeetingID)
                            
                            MeetingSection(date: "Wednesday 10/16", times: [
                                MeetingTimeSlot(time: "4:15 PM - 5:15 PM", votes: 0),
                                MeetingTimeSlot(time: "7:00 PM - 8:00 PM", votes: 1)
                            ], selectedMeetingID: $selectedMeetingID)
                            
                            MeetingSection(date: "Sunday 10/20", times: [
                                MeetingTimeSlot(time: "8:00 PM - 9:00 PM", votes: 3)
                            ], selectedMeetingID: $selectedMeetingID)
                        }
                        .frame(width: .infinity) // Narrowed to 80% width
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
    
    // Reject button with darker background
    private func rejectButton() -> some View {
        Button(action: {
            // Action for Reject
        }) {
            Text("Reject")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.6))
                .cornerRadius(10)
        }
    }
}

// View for each meeting section with a header date and list of time slots
struct MeetingSection: View {
    var date: String
    var times: [MeetingTimeSlot]
    @Binding var selectedMeetingID: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(date)
                .font(.custom("JetBrainsMono-Regular", size: 18))
                .foregroundColor(.white.opacity(0.8))
            
            ForEach(times, id: \.self) { timeSlot in
                timeSlotView(timeSlot: timeSlot)
            }
        }
    }
    
    // Individual time slot with a vote indicator
    private func timeSlotView(timeSlot: MeetingTimeSlot) -> some View {
        Button(action: {
            selectedMeetingID = timeSlot.id
        }) {
            HStack {
                Text(timeSlot.time)
                    .font(.custom("JetBrainsMono-Regular", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(timeSlot.votes)")
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
                selectedMeetingID == timeSlot.id ? AppColors.blueGradient : AppColors.gradientTypedBlack
            )
            .cornerRadius(20) // Rounded corners
            .shadow(color: Color.cyan.opacity(0.5), radius: 5, x: 0, y: 0) // Glow effect for row
        }
    }
}

// Struct for individual meeting time slot
struct MeetingTimeSlot: Hashable, Identifiable {
    var id = UUID()
    var time: String
    var votes: Int
}

// Preview
struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView()
            .previewDevice("iPhone 12")
    }
}
