//
//  VotingViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/19/24.
//

import SwiftUI

class VotingViewModel: ObservableObject {
    @Published var pollOptions: [PollOption] = []
    
    // Decode Poll Options from JSON string
    func decodePollOptions(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(PollOptionResponse.self, from: data)
            if decodedResponse.success {
                self.pollOptions = decodedResponse.response
            } else {
                print("Failed to load poll options")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // Fetch poll options for a specific poll_id
    func loadPollOptions(for pollId: String) {
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
                        self.decodePollOptions(from: data)
                    }
                }
            }
        }.resume()
    }
    
//    func vote(for pollOptionId: String, completion: @escaping (Bool) -> Void) {
//        guard let token = AuthViewModel.retrieveToken() else { return }
//        let url = URL(string: "https://musketeers-django.onrender.com/api/polls/vote")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // create request body
//        let requestBody: [String: Any] = [
//            "token": token,
//            "poll_option_id": pollOptionId
//        ]
//        
//        print(requestBody)
//        // convert to JSON
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//            request.httpBody = jsonData
//        } catch {
//            return
//        }
//        
//        // make API call
//        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
//            if let error = error {
//                print("Error: \(error)")
//                completion(false)
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response status code: \(httpResponse.statusCode)")
//            }
//            
//            if let data = data {
//                // Convert data to string for debugging
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Received data: \(jsonString)")
//                }
//
//                // Decode the response to check for success
//                do {
//                    let decoder = JSONDecoder()
//                    let decodedResponse = try decoder.decode([String: Bool].self, from: data)
//                    if decodedResponse["success"] == true {
//                        completion(true)
//                    } else {
//                        completion(false)
//                    }
//                } catch {
//                    print("Error decoding response: \(error)")
//                    completion(false)
//                }
//            }
//        }
//    }.resume()
//    }
}
