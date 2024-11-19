//
//  PollResultsView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/10/24.
import SwiftUI

struct PollResultsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Black background
                
                VStack(spacing: 20) {
                    // Poll Results title
                    Text("Poll Results")
                        .font(.custom("JetBrainsMono-Regular", size: 28))
                        .foregroundColor(Color.cyan)
                        .padding(.top, 10)
                    
                    // Top Result section
                    Text("Top Result")
                        .font(.custom("JetBrainsMono-Regular", size: 18))
                        .foregroundColor(.white.opacity(0.7))
                    
                    MeetingTimeRow(date: "Monday 10/14", time: "3:00 PM - 4:00 PM")
                    
                    // Other Results section
                    Text("Other Results:")
                        .font(.custom("JetBrainsMono-Regular", size: 18))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        MeetingTimeRow(date: "Monday 10/14", time: "6:00 PM - 7:00 PM")
                        MeetingTimeRow(date: "Sunday 10/20", time: "8:00 PM - 9:00 PM")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
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
        PollResultsView()
            .previewDevice("iPhone 12")
    }
}


