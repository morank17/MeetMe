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
    
    func vote(for poll_option_id: String, completion: @escaping (Bool) -> Void) async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // Create the json body for the POST request
        let jsonData = APICall.createPollJSONBody(token: token, poll_option_id: poll_option_id)
        
        guard let url = URL(string: APIEndpoints.votePoll()) else {
            print("Invalid votePoll URL")
            return
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
            } else {
                print("Failed to send POST request to vote")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
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
