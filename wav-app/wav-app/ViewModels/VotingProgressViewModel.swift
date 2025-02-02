//
//  VotingProgressViewModel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//
import Foundation
import SwiftUI

class VotingProgressViewModel: ObservableObject {
    @Published var polls: [Poll] = []
    
    @MainActor
    func fetchVotingProgress() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        guard let url = URL(string: APIEndpoints.fetchAllPolls(token: token)) else {
            print("Invalid URL for fetchAllPolls")
            return
        }
        
        do {
            let response: PollsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: PollsResponse.self
            )
            if response.success {
                print("Polls Loaded: \(response.response)")
                self.polls = response.response
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
