import EventKit
import Foundation

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

    func fetchCalendarEvents(for dates: [Date], withTimeZone timeZoneIdentifier: String) async {
        let hasAccess = await requestFullCalendarAccess()
        guard hasAccess else {
            print("❌ Access to Calendar Denied")
            return
        }

        var allEventData: [[String: String]] = []
        let calendar = Calendar.current

        // Convert input timezone
        guard let eventTimeZone = TimeZone(identifier: timeZoneIdentifier) else {
            print("⚠️ Invalid timezone identifier: \(timeZoneIdentifier), using system default.")
            return
        }

        // Use DateFormatter instead of ISO8601DateFormatter to exclude timezone offset
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Excludes timezone offset
        dateFormatter.timeZone = eventTimeZone

        for date in dates {
            // Convert query times to given timezone
            let localStartDate = calendar.startOfDay(for: date)
            let utcOffset = eventTimeZone.secondsFromGMT(for: localStartDate)
            let adjustedStartDate = localStartDate.addingTimeInterval(TimeInterval(utcOffset))
            let adjustedEndDate = calendar.date(byAdding: .day, value: 1, to: adjustedStartDate)!

            print("📅 Querying events from \(adjustedStartDate) to \(adjustedEndDate) in \(timeZoneIdentifier)")

            let predicate = store.predicateForEvents(
                withStart: adjustedStartDate,
                end: adjustedEndDate,
                calendars: store.calendars(for: .event)
            )
            let events = store.events(matching: predicate)

            // **Filter out all-day events**
            let filteredEvents = events.filter { !$0.isAllDay }

            let eventData: [[String: String]] = filteredEvents.map { event in
                [
                   // "title": event.title,
                    "start": dateFormatter.string(from: event.startDate), // No timezone offset
                    "end": dateFormatter.string(from: event.endDate) // No timezone offset
                ]
            }

            allEventData.append(contentsOf: eventData)
        }

        // Print the JSON formatted event data
        if let jsonData = try? JSONSerialization.data(withJSONObject: allEventData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📅 Calendar Events (Timezone: \(timeZoneIdentifier)): \n\(jsonString)")
        } else {
            print("⚠️ No events found or failed to format JSON.")
        }
        // **Send collected events to backend**
          await sendEventsToBackend(eventData: allEventData)
    }


    func sendEventsToBackend(eventData: [[String: String]]) async {
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/download") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Wrap the event list inside a dictionary
        let payload: [String: Any] = ["events": eventData]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                let responseText = String(data: data, encoding: .utf8) ?? "No response body"
                print("📡 Response from backend: \(httpResponse.statusCode)")
                print("📜 Response body: \(responseText)")

                if httpResponse.statusCode == 200 {
                    print("✅ Successfully sent event data to backend")
                } else {
                    print("❌ Error sending event data: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("❌ Failed to send event data: \(error.localizedDescription)")
        }
    }

    /// Sends JSON event data to the backend.
//    func sendEventsToBackend(eventData: [[String: String]]) async {
//        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/download") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: [])
//            request.httpBody = jsonData
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    print("✅ Successfully sent event data to backend")
//                } else {
//                    let responseText = String(data: data, encoding: .utf8) ?? "Unknown response"
//                    print("❌ Error sending event data: \(httpResponse.statusCode) - \(responseText)")
//                }
//            }
//        } catch {
//            print("❌ Failed to send event data: \(error.localizedDescription)")
//        }
//    }
}

