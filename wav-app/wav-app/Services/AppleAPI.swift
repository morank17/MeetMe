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
               // .onAppear {
              //      Task {
               //         await calendarFetcher.fetchCalendarEvents(for: <#[Date]#>)
                 //   }
                }
        }
    }

class CalendarFetcher: ObservableObject {
    private let store = EKEventStore()
    /// Requests full access to the user's calendar.
    func requestFullCalendarAccess() async -> Bool {
        if EKEventStore.authorizationStatus(for: .event) == .fullAccess {
            print("Already have full access ✅")
            return true
        }
        do {
            let granted = try await store.requestFullAccessToEvents()
            if granted {
                print("Full access granted ✅")
            } else {
                print("Access denied ❌")
            }
            return granted
        } catch {
            print("Failed to request calendar access: \(error.localizedDescription)")
            return false
        }
    }
    /// Fetches calendar events for the given list of dates, excluding all-day events.
    func fetchCalendarEvents(for dates: [Date]) async {
        let hasAccess = await requestFullCalendarAccess()
        guard hasAccess else { return }
        
        var allEventData: [[String: String]] = []
        let calendar = Calendar.current
        
        for date in dates {
            let startDate = calendar.startOfDay(for: date)
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
            let predicate = store.predicateForEvents(
                withStart: startDate,
                end: endDate,
                calendars: store.calendars(for: .event)
            )
            let events = store.events(matching: predicate)
            
            // **Filter out all-day events**
            let filteredEvents = events.filter { !$0.isAllDay }
            
            let eventData: [[String: String]] = filteredEvents.map { event in
                [
                    "title": event.title,
                    "start": event.startDate.ISO8601Format(),
                    "end": event.endDate.ISO8601Format()
                ]
            }
            
            allEventData.append(contentsOf: eventData)
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: allEventData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Failed to generate JSON")
        }
    }
    
    
    func sendEventsToBackend(eventData: [[String: String]]) async {
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/download") else { return }
        
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
