//
//  VotingDoneView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/14/24.
//

import SwiftUI

struct VotingDoneView: View {
    var body: some View {
        VStack(spacing: 20) {
                    // Title
                    Text("Save Event!")
                        .font(.custom("SFProText-Regular", size: 24))
                        .foregroundStyle(AppColors.blueGradient)
                        .padding(.top, 50)
                    
                    // Event details with gradient background
                    HStack {
                        Text("10/14 Mon, 3PM - 4PM")
                            .font(.custom("SFProText-Medium", size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.cyan, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    
                    // Add to clipboard text
                    Text("Add to Clipboard")
                        .font(.custom("SFProText-Regular", size: 14))
                        .foregroundColor(Color("SubtitleColor"))
                    
                    // Grid of buttons
                    VStack(spacing: 40) { // Vertical spacing between button rows
                        HStack(spacing: 60) { // Horizontal spacing between buttons
                            CircularButton(icon: "plus", label: "Add to Calendar")
                            CircularButton(icon: "bubble.left.and.bubble.right", label: "Text Invite")
                        }
                        HStack(spacing: 60) { // Horizontal spacing between buttons
                            CircularButton(icon: "envelope", label: "Email Invite")
                            CircularButton(icon: "square.and.arrow.up", label: "Other Options")
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }

        // Reusable button component
        struct CircularButton: View {
            let icon: String
            let label: String
            
            var body: some View {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.cyan, lineWidth: 2)
                            .frame(width: 80, height: 100)
                        Image(systemName: icon)
                            .font(.system(size: 30))
                            .foregroundColor(Color.cyan)
                    }
                    Text(label)
                        .font(.custom("SFProText-Regular", size: 18))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
    }
}

#Preview {
    VotingDoneView()
}
