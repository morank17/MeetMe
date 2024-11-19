//
//  NewMeetingViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/6/24.
//

import SwiftUI
class NewMeetingViewModel: ObservableObject { // use an observable object so that the UI automatically rerenders when the Published vars change
    @Published var usernameInput: String = ""
    @Published var addedUsernames: [String] = []
    @Published var errorMessage: String?
    @Published var showSuccessPopup: Bool = false

    
    // Function to query backend for username existence
    func submitUsername() {
        // check that username input is nonempty
        guard !usernameInput.isEmpty else { return }
        
        // Reset the error message
        errorMessage = nil
        
        let url = URL(string: "https://musketeers-django.onrender.com/api/users/checkuname?uname=\(usernameInput)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // initiate asynch network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
            // check connectivity to API
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            if let data = data {
                // Convert data to a string for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received data: \(jsonString)")
                }
            }
            // check valid response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // check if result is true
                
                if let data = data {
                    do {
                        // Decode JSON
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let result = jsonObject["success"] as? Bool {
                            print("Received data: \(result)")
                            // Add username to the added list
                            if result == true {
                                if !self.addedUsernames.contains(self.usernameInput) {
                                    self.addedUsernames.append(self.usernameInput)
                                }
                                // reset usernameInput
                                self.usernameInput = ""
                            } else {
                                self.errorMessage = "User does not exist"
                            }
                        }
                    } catch {
                        self.errorMessage = "Failed to parse JSON: \(error.localizedDescription)"
                    }
                }
            } else {
                self.errorMessage = "Failed to check user. Please try again."
            }
        }}.resume()
    }
    
    // Function to remove a username from the addedUsernames array
    func removeUser(_ username: String) {
        addedUsernames.removeAll { $0 == username }
    }
    
    // Submit a new meeting
    func submitNewMeeting(
        title: String,
        selectedDate: Date,
        timeIntervalStart: Date,
        timeIntervalEnd: Date,
        meetingDurationHrs: Int,
        meetingDurationMins: Int
    ) {
        // catch edge cases
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please add a meeting title."
            return
        }
        
        guard !addedUsernames.isEmpty else {
            errorMessage = "Please add at least one attendee."
            return
        }
        
        guard meetingDurationHrs > 0 || meetingDurationMins > 0 else {
            errorMessage = "Meeting duration must be greater than 0."
            return
        }
        
        errorMessage = nil
        
        let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/setup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // reformat meeting parameters to match backend specs
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let dates = [dayFormatter.string(from: selectedDate)]
        let timeRanges = [[timeFormatter.string(from: timeIntervalStart), timeFormatter.string(from: timeIntervalEnd)]]
        let minMtgMinutes = meetingDurationHrs * 60 + meetingDurationMins
        let unameList = addedUsernames
        guard let token = AuthViewModel.retrieveToken() else { return }
        
        print(title, dates, timeRanges, minMtgMinutes, unameList)

        // create request body
        let requestBody: [String: Any] = [
            "token": token,
            "title": title,
            "dates": dates,
            "time_ranges": timeRanges,
            "uname_list": unameList,
            "min_mtg_minutes": minMtgMinutes
        ]
        
        print(requestBody)
        
        // convert to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            errorMessage = "Failed to encode request body."
            return
        }
        
        // make API call
        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }

                if let data = data {
                    // Convert data to a string for debugging
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received data: \(jsonString)")
                    }
                }
            
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // maybe success popup, navigate back to home page
                    self.showSuccessPopup = true
                    
                    // reset related state variables
                    self.usernameInput = ""
                    self.addedUsernames = []
                } else {
                    self.errorMessage = "Failed to create meeting. Please try again."
                }
            }
        }.resume()
    }
    
}

