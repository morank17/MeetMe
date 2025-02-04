//
//  NewMeetingViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/6/24.
//

import SwiftUI
class NewMeetingViewModel: ObservableObject { // use an observable object so that the UI automatically rerenders when the Published vars change
    // State variables for first screen
    @Published var title: String = ""
    @Published var meetingDurationHrs: Int = 0
    @Published var meetingDurationMins: Int = 0

    // State variables for second screen
    @Published var selectedEarliestDate: Date? = nil
    @Published var selectedLatestDate: Date? = nil
    @Published var timeIntervalStart = Date()
    @Published var timeIntervalEnd = Date()
    
    // UI & Validation
    @Published var errorMessage: String?
    @Published var showSuccessPopup: Bool = false
    @Published var currentPage: Int = 0 // Tracks user progress in the flow
    
    var dateRangeFormatted: [String] {
        guard let startDate = selectedEarliestDate, let endDate = selectedLatestDate else {
            return []
        }
        let calendar = Calendar.current
        var dates: [String] = []
        var currentDate = startDate
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"

        while currentDate <= endDate {
            dates.append(dayFormatter.string(from: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    // Submit a new meeting
    func submitNewMeeting() {
        // catch edge cases
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please add a meeting title."
            return
        }
        guard meetingDurationHrs > 0 || meetingDurationMins > 0 else {
            errorMessage = "Meeting duration must be greater than 0."
            return
        }
        guard timeIntervalStart < timeIntervalEnd else {
            errorMessage = "Start time must be before end time."
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
        
        let dates = dateRangeFormatted
        let timeRanges = [[timeFormatter.string(from: timeIntervalStart), timeFormatter.string(from: timeIntervalEnd)]]
        let minMtgMinutes = meetingDurationHrs * 60 + meetingDurationMins
        guard let token = AuthViewModel.retrieveToken() else { return }
        
        print(title, dates, timeRanges, minMtgMinutes)

        // create request body
        let requestBody: [String: Any] = [
            "token": token,
            "title": title,
            "dates": dates,
            "time_ranges": timeRanges,
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
                } else {
                    self.errorMessage = "Failed to create meeting. Please try again."
                }
            }
        }.resume()
    }
    
}

