//
//  PollResultsViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/19/24.
//

import SwiftUI

class PollResultsViewModel: ObservableObject {
    @Published var pollOptions: [PollOption] = []
    @Published var topPollOption: PollOption? = nil // Store the top poll option
    
    // Fetch poll options for a specific poll_id
    func loadPollResults(for pollId: String) {
        guard let token = AuthViewModel.retrieveToken() else { return }
        let url = URL(string: "https://musketeers-django.onrender.com/api/polls/options?token=\(token)&poll_id=\(pollId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // initiate asynchronous network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.decodePollOptions(from: data)
                    }
                }
            }
        }.resume()
    }

    // Decode Poll Options from JSON and find the top poll option
    func decodePollOptions(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(PollOptionResponse.self, from: data)
            if decodedResponse.success {
                self.pollOptions = decodedResponse.response
                // Identify the poll option with the most votes
                self.topPollOption = decodedResponse.response.max { a, b in
                    a.number_of_votes < b.number_of_votes
                }
            } else {
                print("Failed to load poll options")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
