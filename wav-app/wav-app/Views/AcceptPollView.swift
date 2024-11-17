//
//  AcceptPollView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 11/10/24.
//

import SwiftUI

struct SaveEventView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Black background
                
                VStack(spacing: 30) {
                    // Save Event title
                    Text("Save Event")
                        .font(.custom("JetBrainsMono-Regular", size: 28))
                        .foregroundColor(Color.cyan)
                        .padding(.top, 10)
                    
                    // Event Time Button
                    HStack {
                        Text("10/14")
                            .font(.custom("JetBrainsMono-Regular", size: 18))
                            .bold()
                        
                        Text("Mon, 3PM - 4PM")
                            .font(.custom("JetBrainsMono-Regular", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "link")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
                    
                    // Add to Clipboard
                    Text("Add to Clipboard")
                        .font(.custom("JetBrainsMono-Regular", size: 16))
                        .foregroundColor(Color.cyan.opacity(0.8))
                    
                    // Action buttons
                    HStack(spacing: 30) {
                        ActionButton(icon: "plus", label: "Add to Calendar")
                        ActionButton(icon: "message", label: "Text Invite")
                    }
                    
                    HStack(spacing: 30) {
                        ActionButton(icon: "envelope", label: "Email Invite")
                        ActionButton(icon: "square.and.arrow.up", label: "Other Options")
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing: Text("Settings")
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white))
        }
    }
}

// Custom Action Button View
struct ActionButton: View {
    var icon: String
    var label: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 60, height: 60)
                    .overlay(Circle().stroke(Color.cyan.opacity(0.7), lineWidth: 2))
                    .shadow(color: Color.cyan.opacity(0.7), radius: 5, x: 0, y: 0) // Glow effect
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.custom("JetBrainsMono-Regular", size: 14))
                .foregroundColor(.white)
        }
    }
}

// Preview
struct SaveEventView_Previews: PreviewProvider {
    static var previews: some View {
        SaveEventView()
            .previewDevice("iPhone 16")
    }
}
