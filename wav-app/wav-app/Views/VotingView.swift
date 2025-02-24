//
//  VotingView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/2/24.
//

import SwiftUI

struct VotingView: View {
    @Binding var path: [Destination]
    @State private var selectedPollID: String? = nil
    @State private var showSuccessModal = false
    @State private var isSubmitting = false
    @StateObject var viewModel = VotingViewModel()
    
    var pollId: String
    
    var body: some View {
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
        .background(AppColors.backgroundGray)
        .onAppear {
            Task {
                await viewModel.loadPollOptions(for: pollId)
            }
        }
        .overlay(
            ZStack {
                if showSuccessModal {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                    
                    SuccessModalView(showSuccessModal: $showSuccessModal, path: $path)
                        .scaleEffect(showSuccessModal ? 1 : 0.8)
                        .opacity(showSuccessModal ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showSuccessModal)
                }
            }
        )
    }
    
    private func submitButton() -> some View {
        Button(action: {
            if let selectedPollID = selectedPollID {
                isSubmitting = true
                
                Task {
                    let success = await viewModel.vote(for: selectedPollID)
                    if success {
                        withAnimation {
                            showSuccessModal = true
                        }
                    } else {
                        print("Voting failed, try again")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isSubmitting = false
                    }
                }
            }
        }) {
            Text("SUBMIT")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 172)
                .background(AppColors.highlightBlue)
                .cornerRadius(10)
                .scaleEffect(isSubmitting ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.1), value: isSubmitting)
        }
    }

    
    struct SuccessModalView: View {
        @Binding var showSuccessModal: Bool
        @Binding var path: [Destination]
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Successfully Voted!")
                    .font(TextStyles.subheading)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal, 40)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSuccessModal = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            path = [] // Navigate back to HomeView
                        }
                    }
                }) {
                    Text("Back to Home")
                        .font(TextStyles.selectionlabel)
                        .padding(.vertical, 15)
                        .frame(minWidth: 67, maxWidth: .infinity)
                        .frame(height: 43)
                        .lineLimit(1)
                        .foregroundColor(AppColors.white)
                        .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.highlightBlue))
                }
                .buttonStyle(PlainButtonStyle()) // Removes default button styling
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .frame(width: 300, height: 180) // ✅ Small modal size
            .background(AppColors.backgroundGray)
            .cornerRadius(20)
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .transition(.scale) // ✅ Smooth modal appearance transition
        }
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

                // Use the updated TimeSlotView with selection state
                TimeSlotView(
                    dateTime: pollOption.formattedTime,
                    votes: pollOption.number_of_votes,
                    isSelected: selectedPollID == pollOption.poll_option_id, // Check if selected
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
        VotingView(path: .constant([]), pollId: "8c4a3ad9-a0de-46c5-bfe8-cdfdad8384d7")
            .previewDevice("iPhone 12")
            .background(AppColors.backgroundGray)
    }
}

struct SuccessModalView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView.SuccessModalView(showSuccessModal: .constant(true), path: .constant([]))
            .background(AppColors.backgroundGray)
    }
}
