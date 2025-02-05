//
//  PendingMeetingsViewModel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI

class PendingMeetingsViewModel: ObservableObject {
    @Published var meetings: [Meetings] = []
    
    @MainActor
    func fetchPendingMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
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
                print("Polls Loaded: \(response.response)")
                self.meetings = response.response
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
