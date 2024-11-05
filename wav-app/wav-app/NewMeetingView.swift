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
                
                
                // allow optional attendees
                
                
                // submit button
            }
        }
    }
}

#Preview {
    NewMeetingView()
}
