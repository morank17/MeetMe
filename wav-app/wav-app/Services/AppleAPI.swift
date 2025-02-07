//
//  AppleAPI.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 2/3/25.
//
import EventKit
import Foundation
import SwiftUI

struct MyApp: App {
    @StateObject private var calendarFetcher = CalendarFetcher()
    
    var body: some Scene {
        WindowGroup {
            ConnectCalendarView()
                .onAppear {
                    Task {
                        await calendarFetcher.requestAndFetchEvents()
                    }
                }
        }
    }
}


class CalendarFetcher: ObservableObject {
    private let store = EKEventStore()
   
    func requestAndFetchEvents() async {
        do {
            // Request Full Access to Calendar
            guard try await store.requestFullAccessToEvents() else {
                print("Access Denied")
                return
            }

            // Fetch Calendar Events for Next 7 Days
            let calendar = Calendar.current
            let startDate = Date()
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

            let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: store.calendars(for: .event))
            let events = store.events(matching: predicate)
            
            // Convert Events to JSON-Friendly Format
            let eventData: [[String: String]] = events.compactMap { event in
                return [
                    "title": event.title,
                    "start": event.startDate.ISO8601Format(),
                    "end": event.endDate.ISO8601Format()
                ]
            }
            
            print(eventData)
            // Send to Backend
            await sendEventsToBackend(eventData: eventData)
           
        } catch {
            print("Failed to fetch calendar events: \(error.localizedDescription)")
        }
    }

    func sendEventsToBackend(eventData: [[String: String]]) async {
        guard let url = URL(string: "http://your-backend.com/api/receive_calendar_events/") else { return }
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: [])
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully sent event data to backend")
            } else {
                print("Error sending event data")
            }
        } catch {
            print("Failed to send event data: \(error.localizedDescription)")
        }
    }
}

