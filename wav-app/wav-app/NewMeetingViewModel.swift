//
//  NewMeetingViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/6/24.
//

import SwiftUI
class NewMeetingViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var addedUsernames: [String] = []
    @Published var errorMessage: String?

    // Function to query backend for username existence
    func submitUsername() {
        // check that username input is nonempty
        guard !usernameInput.isEmpty else { return }
        
        // Reset the error message
        errorMessage = nil
        
        let url = URL(string: "https://musketeers-django.onrender.com/api/checkuname?uname=\(usernameInput)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // initiate asynch network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
            // check connectivity to API
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            
            // check valid response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // check if result is true
                if let data = data, let result = String(data: data, encoding: .utf8), result == "true" {
                    
                    // Add username to the added list
                    if !self.addedUsernames.contains(self.usernameInput) {
                        self.addedUsernames.append(self.usernameInput)
                    }
                    // reset usernameInput
                    self.usernameInput = ""
                } else {
                    // Display error if user does not exist
                    self.errorMessage = "User does not exist"
                }
            } else {
                self.errorMessage = "Failed to check user. Please try again."
            }
        }}
    }
    
    // Function to remove a username from the addedUsernames array
    func removeUser(_ username: String) {
        addedUsernames.removeAll { $0 == username }
    }
    
    // Submit a new meeting
    func submitNewMeeting(
        selectedDate: Date,
        timeIntervalStart: Date,
        timeIntervalEnd: Date,
        meetingDurationHrs: Int,
        meetingDurationMins: Int
    ) {
        guard !addedUsernames.isEmpty else {
            errorMessage = "Please add at least one attendee."
            return
        }
        
        guard meetingDurationHrs > 0 || meetingDurationMins > 0 else {
            errorMessage = "Meeting duration must be greater than 0."
            return
        }
        
        errorMessage = nil
        
        let url = URL(string: "https://your-api-endpoint.com/api/new-meeting")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = formatter.string(from: timeIntervalStart)
        let endTime = formatter.string(from: timeIntervalEnd)
        let durationMinutes = meetingDurationHrs * 60 + meetingDurationMins
        let attendees = addedUsernames.joined(separator: ",")
        
        let bodyString = "date=\(formatter.string(from: selectedDate))&start_time=\(startTime)&end_time=\(endTime)&duration=\(durationMinutes)&attendees=\(attendees)"
        request.httpBody = bodyString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.usernameInput = ""
                    self.addedUsernames = []
                } else {
                    self.errorMessage = "Failed to create meeting. Please try again."
                }
            }
        }.resume()
    }
}

