//
//  NewMeetingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/31/24.
//

import SwiftUI

struct NewMeetingView: View {
    @State private var selectedDate = Date()
    @State private var timeIntervalStart = Date()
    @State private var timeIntervalEnd = Date()
    @State private var meetingDurationHrs = 0
    @State private var meetingDurationMins = 0
    @State private var timeRangeErrorMessage: String?
    
    @ObservedObject private var viewModel = NewMeetingViewModel()


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
                                .onChange(of: timeIntervalStart) { oldValue, newValue in
                                    if newValue >= timeIntervalEnd {
                                        timeRangeErrorMessage = "Start time must be before the end time."
                                    } else {
                                        timeRangeErrorMessage = nil
                                    }
                                }
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
                                .onChange(of: timeIntervalEnd) { oldValue, newValue in
                                    if timeIntervalStart >= newValue {
                                        timeRangeErrorMessage = "Start time must be before the end time."
                                    } else {
                                        timeRangeErrorMessage = nil
                                    }
                                }
                        }
                        .frame(width: 160, height: 200)
                        .clipped()
                    }
                    
                }
                if let timeRangeErrorMessage = timeRangeErrorMessage {
                    Text(timeRangeErrorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
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
                                
                
                // submit button (don't need to pass added Usernames because they're already stored in the ViewModel
                Button(action: {
                    viewModel.submitNewMeeting(
                        selectedDate: selectedDate,
                        timeIntervalStart: timeIntervalStart,
                        timeIntervalEnd: timeIntervalEnd,
                        meetingDurationHrs: meetingDurationHrs,
                        meetingDurationMins: meetingDurationMins)
                })
                {Text("Submit Meeting")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    NewMeetingView()
}
