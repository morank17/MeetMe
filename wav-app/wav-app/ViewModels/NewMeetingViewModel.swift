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
    @Published var selectedDuration: String = ""

    // State variables for second screen
    @Published var selectedEarliestDate: Date? = nil
    @Published var selectedLatestDate: Date? = nil
    @Published var selectedTimeSlots: Set<String> = []
    
    // UI & Validation
    @Published var errorMessage: String?
    @Published var currentPage: Int = 0 // Tracks user progress in the flow
    
    // Setup meeting state variables
    @Published var joinCode: String?
    @Published var showSuccessView: Bool = false
    
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
    
    // reset all fields (to be called after successful API request)
    func resetFields() {
        title = ""
        meetingDurationHrs = 0
        meetingDurationMins = 0
        selectedDuration = ""
        selectedEarliestDate = nil
        selectedLatestDate = nil
        selectedTimeSlots = []
        errorMessage = nil
        showSuccessView = false
        joinCode = nil
    }
    
    // merge time intervals in to continuous ones (basically leetcode problem)
    func getMergedTimeRanges() -> [[String]] {
        let timeSlotMapping: [String: (start: String, end: String)] = [
            "7am-11am": ("07:00", "11:00"),
            "11am-3pm": ("11:00", "15:00"),
            "3pm-7pm": ("15:00", "19:00"),
            "7pm-11pm": ("19:00", "23:00")
        ]
        
        var intervals: [(String, String)] = selectedTimeSlots.compactMap { timeSlotMapping[$0] }
        intervals.sort { $0.0 < $1.0 } // Sort intervals by start time
        
        var mergedIntervals: [[String]] = []
        var currentInterval: (String, String)? = nil

        for interval in intervals {
            if let current = currentInterval {
                // Merge consecutive intervals
                if current.1 == interval.0 {
                    currentInterval = (current.0, interval.1) // Extend the interval
                } else {
                    mergedIntervals.append([current.0, current.1])
                    currentInterval = interval
                }
            } else {
                currentInterval = interval
            }
        }
        
        if let current = currentInterval {
            mergedIntervals.append([current.0, current.1]) // Add the last merged interval
        }
        
        return mergedIntervals
    }
    
    // get timezone of users phone
    func getUTCOffset() -> String {
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        let hours = secondsFromGMT / 3600
        let minutes = abs(secondsFromGMT % 3600) / 60
        return String(format: "%+03d:%02d", hours, minutes)
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
        
        errorMessage = nil
        
        let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/setup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // reformat meeting parameters to match backend specs
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        let dates = dateRangeFormatted
        let timeRanges = getMergedTimeRanges()
        let minMtgMinutes = meetingDurationHrs * 60 + meetingDurationMins
        let timezone = getUTCOffset()
        guard let token = AuthViewModel.retrieveToken() else { return }
        
        print(title, dates, timeRanges, minMtgMinutes)

        // create request body
        let requestBody: [String: Any] = [
            "token": token,
            "title": title,
            "dates": dates,
            "time_ranges": timeRanges,
            "minimum_duration_in_minutes": minMtgMinutes,
            "timezone_str": timezone,
            "max_n_victors": 20
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
            
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                   let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let joinCode = jsonResponse["join-code"] as? String {
                            print("hello")
                            self.joinCode = joinCode
                            self.showSuccessView = true
                        }
                    } catch {
                        self.errorMessage = "Failed to parse response."
                    }
                } else {
                    self.errorMessage = "Failed to create meeting. Please try again."
                }
            
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }

            }
        }.resume()
    }
    
}

