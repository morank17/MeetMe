//
//  ContentView.swift
//  wav-app
//
//
//   Edited by Nikola Dimitrijevic on 10/30/24

// Define a struct for Meeting that conforms to Identifiable and Hashable
import SwiftUI

struct Meeting: Identifiable, Hashable {
    var id = UUID()
    var date: String
    var time: String
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // "Create a MeetMe!" button
                createMeetMeButton()
                
                // Title for the Meet Queue
                Text("Meet Queue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                // Meeting Queue list
                VStack(spacing: 10) {
                    ForEach(getMeetings()) { meeting in
                        meetingRow(meeting: meeting)
                    }
                }
                
                // Bottom text indicating no more meetings
                Text("You’re all set on meetings!")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // Extracted "Create a MeetMe!" button as a separate view
    private func createMeetMeButton() -> some View {
        Button(action: {
            // Action for creating a new meeting
        }) {
            Text("Send A WAYV")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(20)
                .padding(.horizontal, 40)
        }
    }
    
    // Extracted meeting row as a separate view
    private func meetingRow(meeting: Meeting) -> some View {
        HStack {
            Text(meeting.date)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            Text(meeting.time)
                .foregroundColor(.white)
            Button(action: {
                // Action for copying meeting details
            }) {
                Image(systemName: "doc.on.doc.fill")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.cyan, lineWidth: 1)
                .shadow(color: Color.cyan.opacity(0.5), radius: 8, x: 0, y: 0)
        )
        .padding(.horizontal)
    }
    
    // Sample data function for Meet Queue
    func getMeetings() -> [Meeting] {
        return [
            Meeting(date: "10/14", time: "3:00PM - 4:00PM"),
            Meeting(date: "10/19", time: "11:30AM - 1:00PM"),
            Meeting(date: "10/20", time: "11:00AM - 12:00PM")
        ]
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
