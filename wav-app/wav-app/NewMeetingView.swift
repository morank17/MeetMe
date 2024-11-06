//
//  NewMeetingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/31/24.
//

import SwiftUI

class InviteViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var addedUsernames: [String] = []
    @Published var errorMessage: String?

    // Function to query backend for username existence
    func submitUsername() {
        // check that username input is nonempty
        guard !usernameInput.isEmpty else { return }
        
        // Reset the error message
        errorMessage = nil
        
        let url = URL(string: "http://127.0.0.1:8000/users/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type")
        
        let bodyString = "uname=\(usernameInput)"
        request.httpBody = bodyString.data(using: .utf8)
        
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
            }
        }
    }
    
    // Function to remove a username from the addedUsernames array
    func removeUser(_ username: String) {
        addedUsernames.removeAll { $0 == username }
    }
}

struct NewMeetingView: View {
    @State private var selectedDate = Date()
    @State private var timeIntervalStart = Date()
    @State private var timeIntervalEnd = Date()
    @State private var meetingDurationHrs = 0
    @State private var meetingDurationMins = 0
    
    @ObservedObject private var viewModel = InviteViewModel()


    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // pick day for meeting
                // might want to create some support to select multiple days
                Text("Select a Date")
                    .font(.headline)
                
                DatePicker(
                    "Choose a day",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                // pick start and end time for search
                Text("Select a Time Interval")
                    .font(.headline)
                
                HStack (spacing: 10) {
                    VStack {
                        Text("Start")
                        ZStack {
                            DatePicker("Start Time", selection: $timeIntervalStart, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .scaleEffect(0.8)
                        }
                        // frame in zstack cuts off datepicker elements so they can fit side by side
                        .frame(width: 160, height: 200)
                        .clipped()
                    }
                    Rectangle()
                        .frame(width: 1, height: 160) // Adjust height as needed
                        .foregroundColor(.gray)
                    
                    VStack {
                        Text("End")
                        ZStack {
                            DatePicker("End Time", selection: $timeIntervalEnd, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(WheelDatePickerStyle())
                                .scaleEffect(0.8)
                        }
                        .frame(width: 160, height: 200)
                        .clipped()
                    }
                    
                }
                
                // pick duration of meeting
                Text("Select Meeting Duration")
                    .font(.headline)
                HStack(spacing: 0) {
                    // Hours Picker
                    VStack {
                        Text("hrs")
                        Picker("Hours", selection: $meetingDurationHrs) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)")
                                    .tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                        .clipped()
                    }
                    VStack {
                        Text("min")
                        // Minutes Picker
                        Picker("Minutes", selection: $meetingDurationMins) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)")
                                    .tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                        .clipped()
                    }
                }
                
                // add attendees
                Text("Add Attendees")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Enter username", text: $viewModel.usernameInput)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button(action: {
                        viewModel.submitUsername()
                    }) {
                        Text("Add User")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                    
                    // Display added usernames
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.addedUsernames, id: \.self) { username in
                                HStack {
                                    Text(username)
                                        .padding(8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        viewModel.removeUser(username)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.top, 16)
                }
                .padding(.top, 8)
                
                // allow optional attendees
                
                
                // submit button
            }
        }
    }
}

#Preview {
    NewMeetingView()
}
