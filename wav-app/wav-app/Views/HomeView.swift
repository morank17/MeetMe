//
//  HomeView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 10/30/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // ViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Dark background color
                
                VStack(spacing: 20) {
                    // "Send a Wayv" button with blue gradient and glow
                    sendWayvButton()
                    
                    // Sections with titles and meeting rows
                    ForEach(getGroupedPolls().sorted(by: { $0.key < $1.key }), id: \.key) { section, polls in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section)
                                .font(.custom("JetBrainsMono-Regular", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            ForEach(polls) { poll in
                                pollRow(poll: poll)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .font(.custom("JetBrainsMono-Regular", size: 16))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                // Load data when the view appears
                viewModel.loadSampleData()
            }
        }
    }
    
    // "Send a Wayv" button with blue gradient and glow effect
    private func sendWayvButton() -> some View {
        NavigationLink(destination: NewMeetingView()) {
            Text("Send a WAYV")
                .font(.custom("JetBrainsMono-Regular", size: 20))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(20)
                .padding(.horizontal, 40)
                .shadow(color: Color.cyan.opacity(0.7), radius: 10, x: 0, y: 0) // Glow effect
        }
    }
    
    // Meeting row view with blue gradient background and glow effect
    private func pollRow(poll: Poll) -> some View {
        NavigationLink(
            destination: destinationView(for: poll.is_closed, pollId: poll.poll_id) // Dynamically select destination
        ) {
            HStack {
                Text(poll.title)
                    .font(.custom("JetBrainsMono-Regular", size: 16))
                    .foregroundColor(.white)
                    .bold()
                
                if poll.is_closed {
                    // Show the formatted date and time for closed polls
                    if let date = poll.formattedDate, let time = poll.formattedTime {
                        Text("\(date), \(time)")
                            .font(.custom("JetBrainsMono-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                } else {
                    // Show the voting fraction for open polls
                    Text("\(poll.voteFraction) of users voted")
                        .font(.custom("JetBrainsMono-Regular", size: 16))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    // Action for copying poll details (e.g., to clipboard)
                }) {
                    Image(systemName: "doc.on.doc.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(color: Color.cyan.opacity(0.7), radius: 10, x: 0, y: 0) // Glow effect
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                .shadow(color: Color.cyan.opacity(0.3), radius: 8, x: 0, y: 0)
        )
    }
    
    func destinationView(for isClosed: Bool, pollId: String) -> some View {
        if isClosed {
            return AnyView(VotingDoneView(pollId: pollId))
        } else {
            return AnyView(VotingView(pollId: pollId))
        }
    }
    
    // Group meetings by their status
    func getGroupedPolls() -> [String: [Poll]] {
        let polls = viewModel.polls
        return Dictionary(grouping: polls, by: { $0.is_closed ? "Voting Done" : "Voting Active" })
    }
}

// Renamed to avoid redeclaration error
struct SettingsPlaceholderView: View {
    var body: some View {
        Text("Settings")
            .font(.custom("JetBrainsMono-Regular", size: 18))
            .foregroundColor(.white)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
