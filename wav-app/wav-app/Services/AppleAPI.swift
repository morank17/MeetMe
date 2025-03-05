import EventKit
import Foundation

class CalendarFetcher: ObservableObject {
    private let store = EKEventStore()
    
    /// Checks if we already have full calendar access (non-interactive, no prompt).
    func checkFullCalendarAccess() -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        return status == .fullAccess
    }
    
    /// Requests full access to the user's calendar (only called explicitly from the button).
    func requestFullCalendarAccess() async -> Bool {
        if checkFullCalendarAccess() {
            print("✅ Already have full access")
            return true
        }
        do {
            let granted = try await store.requestFullAccessToEvents()
            if granted {
                print("✅ Full access granted")
            } else {
                print("❌ Access denied")
            }
            return granted
        } catch {
            print("❌ Failed to request calendar access: \(error.localizedDescription)")
            return false
        }
    }

    /// Fetches calendar events using `yyyy-MM-dd` formatted date strings.
    func fetchCalendarEvents(for dateStrings: [String], withTimeZone timeZoneIdentifier: String) async -> [[String: String]] {
        guard checkFullCalendarAccess() else {
            print("❌ Access to Calendar Denied - No events fetched.")
            return []
        }
        
        var allEventData: [[String: String]] = []
        let calendar = Calendar.current
        
        guard let eventTimeZone = timeZoneFromOffset(timeZoneIdentifier) else {
            print("⚠️ Failed to determine timezone from offset: \(timeZoneIdentifier), using system default.")
            return []
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.timeZone = eventTimeZone
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        outputFormatter.timeZone = eventTimeZone
        
        for dateString in dateStrings {
            guard let date = inputFormatter.date(from: dateString) else {
                print("⚠️ Invalid date format: \(dateString), skipping...")
                continue
            }
            
            let localStartDate = calendar.startOfDay(for: date)
            let utcOffset = eventTimeZone.secondsFromGMT(for: localStartDate)
            let adjustedStartDate = localStartDate.addingTimeInterval(TimeInterval(utcOffset))
            let adjustedEndDate = calendar.date(byAdding: .day, value: 1, to: adjustedStartDate)!
            
            let predicate = store.predicateForEvents(
                withStart: adjustedStartDate,
                end: adjustedEndDate,
                calendars: store.calendars(for: .event)
            )
            
            let events = store.events(matching: predicate).filter { !$0.isAllDay }
            
            let eventData: [[String: String]] = events.map { event in
                [
                    "start": outputFormatter.string(from: event.startDate),
                    "end": outputFormatter.string(from: event.endDate)
                ]
            }
            allEventData.append(contentsOf: eventData)
        }
        
        return allEventData
    }

    /// Converts a UTC offset (e.g., "-5:00") into a `TimeZone` object.
    func timeZoneFromOffset(_ offsetString: String) -> TimeZone? {
        let components = offsetString.split(separator: ":")
        guard let hours = Int(components[0]) else {
            print("❌ Invalid timezone offset format: \(offsetString)")
            return nil
        }
        let secondsFromGMT = hours * 3600
        
        let matchingTimeZone = TimeZone.knownTimeZoneIdentifiers
            .compactMap { TimeZone(identifier: $0) }
            .first { $0.secondsFromGMT() == secondsFromGMT }
        
        if let matchedZone = matchingTimeZone {
            print("✅ Found matching timezone: \(matchedZone.identifier) for offset \(offsetString)")
        } else {
            print("⚠️ No exact timezone match found for offset \(offsetString), using system default.")
        }
        return matchingTimeZone ?? TimeZone.current
    }

    /// Sends collected events to the backend.
    func sendEventsToBackend(datesList: [String], timeZoneStr: String) async {
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/download") else {
            print("❌ Invalid backend URL")
            return
        }
        guard let token = AuthViewModel.retrieveToken(), !token.isEmpty else {
            print("❌ Token is missing!")
            return
        }

        let hasAppleAccess = checkFullCalendarAccess()  // ✅ Use check, not request
        
        let payload: [String: Any]
        if hasAppleAccess {
            print("✅ Apple access granted, fetching events...")
            let appleEvents = await fetchCalendarEvents(for: datesList, withTimeZone: timeZoneStr)
            payload = [
                "token": token,
                "selected_cal_system": "Apple",
                "events": appleEvents
            ]
        } else {
            print("⚠️ Apple access denied, defaulting to Google payload.")
            payload = [
                "token": token,
                "selected_cal_system": "Google",
                "dates_list": datesList,
                "timezone_str": timeZoneStr
            ]
        }
        
        await sendPayload(url: url, payload: payload)
    }

    /// Sends the payload to the backend.
    private func sendPayload(url: URL, payload: [String: Any]) async {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                let responseText = String(data: data, encoding: .utf8) ?? "No response body"
                print("📩 Response: \(httpResponse.statusCode)\n📝 Body: \(responseText)")
            }
        } catch {
            print("❌ Failed to send data: \(error.localizedDescription)")
        }
    }

    /// Generates and sends the event payload.
    private func generateEventPayload(loginCode: String, selectedCalSystem: String) async {
        guard let token = AuthViewModel.retrieveToken(), !token.isEmpty else {
            print("❌ Token is missing!")
            return
        }
        
        let payload: [String: Any] = [
            "token": token,
            "join-code": loginCode,
            "selected_cal_system": selectedCalSystem
        ]
        await sendPayload(url: URL(string: "https://musketeers-django.onrender.com/api/meetings/addback")!, payload: payload)
    }

    /// Creates an Apple Calendar event or defaults to Google if access denied.
    func createAppleEvent(title: String,
                          winningStartDateTime: String,
                          winningEndDateTime: String,
                          timeZoneStr: String,
                          participants: [String],
                          loginCode: String) async {
        guard checkFullCalendarAccess() else {
            print("❌ No Apple Calendar access. Defaulting to Google.")
            await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
            return
        }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let inputStart = isoFormatter.date(from: winningStartDateTime),
              let inputEnd = isoFormatter.date(from: winningEndDateTime) else {
            print("❌ Invalid date format, defaulting to Google.")
            await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
            return
        }

        let eventTimeZone = timeZoneFromOffset(timeZoneStr) ?? .current
        let userTimeZone = TimeZone.current
        
        let convertedStart = inputStart + TimeInterval(userTimeZone.secondsFromGMT() - eventTimeZone.secondsFromGMT())
        let convertedEnd = inputEnd + TimeInterval(userTimeZone.secondsFromGMT() - eventTimeZone.secondsFromGMT())

        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = convertedStart
        event.endDate = convertedEnd
        event.timeZone = userTimeZone
        event.notes = participants.isEmpty ? "No attendees listed" : "Attendees: " + participants.joined(separator: ", ")
        event.calendar = store.defaultCalendarForNewEvents

        do {
            try store.save(event, span: .thisEvent)
            await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Apple")
        } catch {
            print("❌ Failed to save Apple event, defaulting to Google.")
            await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
        }
    }
}

