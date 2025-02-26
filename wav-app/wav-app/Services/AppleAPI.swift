import EventKit
import Foundation

class CalendarFetcher: ObservableObject {
    private let store = EKEventStore()
    
    /// Requests full access to the user's calendar.
    func requestFullCalendarAccess() async -> Bool {
        if EKEventStore.authorizationStatus(for: .event) == .fullAccess {
            print("Already have full access ")
            return true
        }
        do {
            let granted = try await store.requestFullAccessToEvents()
            if granted {
                print("Full access granted ")
            } else {
                print("Access denied ")
            }
            return granted
        } catch {
            print("Failed to request calendar access: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Fetches calendar events using `yyyy-MM-dd` formatted date strings.
    func fetchCalendarEvents(for dateStrings: [String], withTimeZone timeZoneIdentifier: String) async -> [[String: String]] {
        let hasAccess = await requestFullCalendarAccess()
        guard hasAccess else {
            print(" Access to Calendar Denied")
            return []
        }
        
        var allEventData: [[String: String]] = []
        let calendar = Calendar.current
        
        guard let eventTimeZone = timeZoneFromOffset(timeZoneIdentifier) else {
            print(" Failed to determine timezone from offset: \(timeZoneIdentifier), using system default.")
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
                print(" Invalid date format: \(dateString), skipping...")
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
            let events = store.events(matching: predicate)
            
            let filteredEvents = events.filter { !$0.isAllDay }
            
            let eventData: [[String: String]] = filteredEvents.map { event in
                [
                    "start": outputFormatter.string(from: event.startDate),
                    "end": outputFormatter.string(from: event.endDate)
                ]
            }
            
            allEventData.append(contentsOf: eventData)
        }
        
        return allEventData
    }
    
    
    /// Converts a UTC offset (e.g., "-5:00") into a valid `TimeZone` object.
    func timeZoneFromOffset(_ offsetString: String) -> TimeZone? {
        let components = offsetString.split(separator: ":")
        guard let hours = Int(components[0]) else {
            print(" Invalid timezone offset format: \(offsetString)")
            return nil
        }
        
        let secondsFromGMT = hours * 3600
        
        let possibleTimeZones = TimeZone.knownTimeZoneIdentifiers.compactMap { TimeZone(identifier: $0) }
        let matchingTimeZone = possibleTimeZones.first { $0.secondsFromGMT() == secondsFromGMT }
        
        if let matchedZone = matchingTimeZone {
            print("Found matching timezone: \(matchedZone.identifier) for offset \(offsetString)")
        } else {
            print(" No exact timezone match found for offset \(offsetString), using system default.")
        }
        
        return matchingTimeZone ?? TimeZone.current // Default to system timezone if no match
    }
    
    /// Sends collected events to the backend.
    func sendEventsToBackend(datesList: [String], timeZoneStr: String) async {
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/download") else {
            print(" Invalid backend URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = AuthViewModel.retrieveToken(), !token.isEmpty else {
            print(" Token is missing!")
            return
        }
        
        let fetcher = CalendarFetcher()
        let hasAppleAccess = await fetcher.requestFullCalendarAccess()
        
        if hasAppleAccess {
            print(" Apple access granted, fetching events...")
            let appleEvents = await fetcher.fetchCalendarEvents(for: datesList, withTimeZone: timeZoneStr)
            
            // Apple Payload
            let payload: [String: Any] = [
                "token": token,
                "selected_cal_system": "Apple",
                "events": appleEvents,
//                "dates_list": datesList,
//                "timezone_str": timeZoneStr
            ]
            
            print(" Sending Apple payload: \(payload)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
                request.httpBody = jsonData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    let responseText = String(data: data, encoding: .utf8) ?? "No response body"
                    print("Response from backend: \(httpResponse.statusCode)")
                    print(" Response body: \(responseText)")
                    
                    if httpResponse.statusCode == 200 {
                        print(" Successfully sent Apple event data to backend")
                    } else {
                        print(" Error sending Apple event data: \(httpResponse.statusCode)")
                    }
                }
            } catch {
                print("Failed to send Apple event data: \(error.localizedDescription)")
            }
            
        } else {
            print(" Apple access denied, defaulting to Google payload.")
            
            // Google Payload (Empty events list)
            let payload: [String: Any] = [
                "token": token,
                "selected_cal_system": "Google",
//                "events": [],
                "dates_list": datesList,
                "timezone_str": timeZoneStr
            ]
            
            print(" Sending Google payload: \(payload)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
                request.httpBody = jsonData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    let responseText = String(data: data, encoding: .utf8) ?? "No response body"
                    print(" Response from backend: \(httpResponse.statusCode)")
                    print(" Response body: \(responseText)")
                    
                    if httpResponse.statusCode == 200 {
                        print(" Successfully sent Google payload with empty events.")
                    } else {
                        print("Error sending Google payload: \(httpResponse.statusCode)")
                    }
                }
            } catch {
                print(" Failed to send Google event data: \(error.localizedDescription)")
            }
        }
    }
    private func isAppleCalendarConnected() async -> Bool {
           return await requestFullCalendarAccess()
       }

     
    /// Sends event payload to backend
    private func sendEventPayloadToBackend(payload: [String: Any]) async {
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/meetings/addback") else {
            print("❌ Invalid backend URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                let responseText = String(data: data, encoding: .utf8) ?? "No response body"
                print("📩 Response from backend: \(httpResponse.statusCode)")
                print("📝 Response body: \(responseText)")
                
                if httpResponse.statusCode == 200 {
                    print("✅ Successfully sent event payload to backend")
                } else {
                    print("⚠️ Error sending event payload: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("❌ Failed to send event payload: \(error.localizedDescription)")
        }
    }

    /// Generates and sends the JSON payload with selected calendar system, token, and login code
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
        
        print("✅ Generated payload: \(payload)")
        
        // Send the payload to the backend
        await sendEventPayloadToBackend(payload: payload)
    }

    /// Creates an Apple Calendar event with timezone conversion and sends payload
        func createAppleEvent(title: String,
                              winningStartDateTime: String,
                              winningEndDateTime: String,
                              timeZoneStr: String,
                              participants: [String],
                              loginCode: String) async {
            let hasAccess = await requestFullCalendarAccess()
            
            if !hasAccess {
                print("❌ Access to Apple Calendar Denied. Defaulting to Google.")
                _ = await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
                return
            }
            
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime]

            // Convert the provided ISO 8601 strings to Date objects
            guard let inputStartDate = isoFormatter.date(from: winningStartDateTime),
                  let inputEndDate = isoFormatter.date(from: winningEndDateTime) else {
                print("❌ Invalid date format: \(winningStartDateTime) - \(winningEndDateTime). Defaulting to Google.")
                _ = await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
                return
            }

            // Convert provided timezone string into a TimeZone object
            let eventTimeZone = timeZoneFromOffset(timeZoneStr) ?? TimeZone.current

            // Convert event times to the user's local timezone
            let userTimeZone = TimeZone.current
            let startTimeDifference = TimeInterval(userTimeZone.secondsFromGMT(for: inputStartDate) - eventTimeZone.secondsFromGMT(for: inputStartDate))
            let convertedStartDate = inputStartDate.addingTimeInterval(startTimeDifference)

            let endTimeDifference = TimeInterval(userTimeZone.secondsFromGMT(for: inputEndDate) - eventTimeZone.secondsFromGMT(for: inputEndDate))
            let convertedEndDate = inputEndDate.addingTimeInterval(endTimeDifference)

            let event = EKEvent(eventStore: store)
            event.title = title
            event.startDate = convertedStartDate
            event.endDate = convertedEndDate
            event.timeZone = userTimeZone // Ensure it is set to the user's timezone

            // Add attendees to the description
            let attendeesText = participants.isEmpty ? "No attendees listed" : "Attendees: " + participants.joined(separator: ", ")
            event.notes = attendeesText

            event.calendar = store.defaultCalendarForNewEvents

            do {
                try store.save(event, span: .thisEvent)
                print("✅ Event created: \(title) from \(event.startDate!) to \(event.endDate!) in \(userTimeZone.identifier)")
                
                // Send payload with Apple as the selected calendar system
                _ = await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Apple")
                
            } catch {
                print("❌ Failed to save event in Apple Calendar: \(error.localizedDescription). Defaulting to Google.")
                
                // Send payload with Google as the selected calendar system
                _ = await generateEventPayload(loginCode: loginCode, selectedCalSystem: "Google")
            }
        }
    }


