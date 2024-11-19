//
//  HomeViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/19/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var polls: [Poll] = []
        
    // Decode Polls from JSON string
    func decodePolls(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(PollsResponse.self, from: data)
            if decodedResponse.success {
                self.polls = decodedResponse.response
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // Sample data or fetch from API
    func loadSampleData() {
        guard let token = AuthViewModel.retrieveToken() else { return }
        let url = URL(string: "https://musketeers-django.onrender.com/api/polls?token=\(token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // initiate asynch network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            if let data = data {
                // Convert data to a string for debugging purposes
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received data: \(jsonString)")
                }
                // Check if the response is valid (status code 200)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.decodePolls(from: data)
                }
            }
        }
    }.resume()
    }
}
