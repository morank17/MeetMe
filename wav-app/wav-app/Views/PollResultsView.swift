//
//  PollResultsView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/10/24.
import SwiftUI

struct PollResultsView: View {
    var pollId: String
    @StateObject var viewModel = PollResultsViewModel()
    
    var body: some View {
        NavigationView {
            Color(AppColors.backgroundGray).edgesIgnoringSafeArea(.all) // Dark background color
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Black background
                
                VStack(spacing: 20) {
                    // Poll Results title
                    Text("Poll Results")
                        .font(.custom("JetBrainsMono-Regular", size: 28))
                        .foregroundColor(Color.cyan)
                        .padding(.top, 10)
                    
                    // Top Result section
                    if let topPollOption = viewModel.topPollOption {
                        Text("Top Result")
                            .font(.custom("JetBrainsMono-Regular", size: 18))
                            .foregroundColor(.white.opacity(0.7))
                        
                        MeetingTimeRow(date: topPollOption.formattedDate, time: topPollOption.formattedTime)
                    }
                    // Other Results section
                    Text("Other Results:")
                        .font(.custom("JetBrainsMono-Regular", size: 18))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        ForEach(viewModel.pollOptions.filter { $0.poll_option_id != viewModel.topPollOption?.poll_option_id }) { pollOption in
                            MeetingTimeRow(date: pollOption.formattedDate, time: pollOption.formattedTime)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .onAppear {
                    viewModel.loadPollResults(for: pollId) // Load poll results when view appears
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    // View for each meeting time slot with date and time
    struct MeetingTimeRow: View {
        var date: String
        var time: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(date)
                    .font(.custom("JetBrainsMono-Regular", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(time)
                    .font(.custom("JetBrainsMono-Regular", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
            }
            .padding(.horizontal)
        }
    }
    
    // Preview
    struct PollResultsView_Previews: PreviewProvider {
        static var previews: some View {
            PollResultsView(pollId: "f4685efe-690a-4c8c-86d0-60dedfa3f7b9")
                .previewDevice("iPhone 12")
        }
    }
    
    
}
