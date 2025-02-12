//
//  PendingMeetingsViewModel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI

// Note: PendingMeeting is the same as JoinPeriodMeeting on Backend.
class PendingMeetingsViewModel: ObservableObject {
    // JoinPeriodMeeting comes from ./Models/Meetings
    @Published var pendingMeetings: [JoinPeriodMeeting] = []
    
    // Get the pending meetings
    @MainActor
    func fetchPendingMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // fetchPendingMeetings defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.fetchPendingMeetings(token: token)) else {
            print("Invalid URL for fetchPendingMeetings")
            return
        }
        
        do {
            let response: MeetingsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: MeetingsResponse.self
            )
            if response.success {
                print("Pending Meetings Loaded: \(response.response)")
                self.pendingMeetings = response.response // assigning the response to the model JoinPeriodMeeting
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
