//
//  CompletedMeetingsViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/24/25.
//

import SwiftUI

class CompletedMeetingsViewModel: ObservableObject {
    @Published var completedMeetings: [CompletedMeeting] = []

    // Get the completed meetings
    @MainActor
    func fetchCompletedMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // fetchCompletedMeetings defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.fetchCompletedMeetings(token: token)) else {
            print("Invalid URL for fetchCompletedMeetings")
            return
        }
        
        do {
            let response: CompletedMeetingsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: CompletedMeetingsResponse.self
            )
            if response.success {
                print("Completed Meetings Loaded: \(response.response)")
                self.completedMeetings = response.response
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func declineMeeting() {
        print("hello")
    }
    
    func acceptMeeting() {
        print("hello")
    }
}

