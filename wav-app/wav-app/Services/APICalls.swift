//
//  APICalls.swift
//  wav-app
//
//  Created by Matthew Kim on 1/26/25.
//

import Foundation
import SwiftUI

class APICall {
    static let shared = APICall()
    private init() {}
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    // T is a placeholder for the type of the decoded response (struct)
    func loginRequest(
        url: URL,
        method: String = "GET", // "GET" is default value. Can also use "POST", "PUT", "DELETE"
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Print HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            // Ensure we have data
            guard let data = data else {
                print("Failed to create account. No data received.")
                return
            }
            
            // Safely handle JSON parsing with do-catch
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = jsonObject["token"] as? String {
                    // Save the token
                    AuthViewModel.saveToken(token: token)
                    self.isLoggedIn = true
                    print("Token saved successfully: \(token)")
                    return
                } else {
                    print("Token not found in response")
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
