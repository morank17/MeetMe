//
//  VotingViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/19/24.
//

import SwiftUI

class VotingViewModel: ObservableObject {
    @Published var pollOptions: [PollOption] = []
    
    // Fetch poll options for a specific poll_id
    @MainActor
    func loadPollOptions(for poll_id: String) async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        guard let url = URL(string: APIEndpoints.fetchPollOptions(token: token, poll_id: poll_id)) else {
            print("Invalid URL for fetchPollOptions")
            return
        }
        
        do {
            let response: PollOptionResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: PollOptionResponse.self
            )
            if response.success {
                print("Poll Options Loaded: \(response.response)")
                self.pollOptions = response.response // assigning the response to the model JoinPeriodMeeting
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    func vote(for poll_option_id: String) async -> Bool {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return false
        }
        
        // Create the json body for the POST request
        let jsonData = APICall.createPollJSONBody(token: token, poll_option_id: poll_option_id)
        
        guard let url = URL(string: APIEndpoints.votePoll()) else {
            print("Invalid votePoll URL")
            return false
        }
        
        do {
            let response: PostResponse = try await APICall.request(
                url: url,
                method: "POST",
                headers: ["Content-Type": "application/json"],
                body: jsonData,
                responseType: PostResponse.self
            )
            if response.success {
                print("POST vote poll Sucess!")
                return true
            } else {
                print("Failed to send POST request to vote")
                return false
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            return false
        }
    }
}
