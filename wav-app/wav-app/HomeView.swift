//
//  HomeView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 10/30/24.
//

import SwiftUI

// Define a struct for Meeting that conforms to Identifiable and Hashable
struct Meeting: Identifiable, Hashable {
    var id = UUID()
    var date: String
    var time: String
    var status: String // New status property to group meetings
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Dark background color
                
                VStack(spacing: 20) {
                    // "Send a Wayv" button with blue gradient and glow
                    sendWayvButton()
                    
                    // Sections with titles and meeting rows
                    ForEach(getGroupedMeetings().sorted(by: { $0.key < $1.key }), id: \.key) { section, meetings in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section)
                                .font(.custom("JetBrainsMono-Regular", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            ForEach(meetings) { meeting in
                                meetingRow(meeting: meeting)
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
    private func meetingRow(meeting: Meeting) -> some View {
        HStack {
            Text(meeting.date)
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
                .bold()
            
            Text(meeting.time)
                .font(.custom("JetBrainsMono-Regular", size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Action for copying meeting details
            }) {
                Image(systemName: "doc.on.doc.fill")
                    .foregroundColor(.white)
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
    
    // Sample data function with status categories for Meet Queue
    func getMeetings() -> [Meeting] {
        return [
            Meeting(date: "7/9", time: "30 min left", status: "Waiting for Attendees"),
            Meeting(date: "3/3", time: "2 hrs 15 min left", status: "Waiting for Attendees"),
            Meeting(date: "7/9", time: "30 min left", status: "Voting Active"),
            Meeting(date: "3/3", time: "2 hrs 15 min left", status: "Voting Active"),
            Meeting(date: "10/14", time: "3:00PM - 4:00PM", status: "Voting Done"),
            Meeting(date: "10/19", time: "11:30AM - 1:00PM", status: "Voting Done")
        ]
    }
    
    // Group meetings by their status
    func getGroupedMeetings() -> [String: [Meeting]] {
        let meetings = getMeetings()
        return Dictionary(grouping: meetings, by: { $0.status })
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
