//
//  ConnectCalendarView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/14/24.
//

import SwiftUI

struct ConnectCalendarView: View {
    @State private var loginMessage = "Not Logged In to Calendar"
    @State private var googleSignInURL: String = ""
    
    var body: some View {
        VStack {
            Button("Connect Google Calendar") {
                Task {
                    do {
                        googleSignInURL = try await getGoogleSignInURL()
                        startSignInWithGoogle()
                    } catch {
                        loginMessage = "Failed to get sign-in URL. Please try again."
                        print("Error: \(error)")
                    }
                }
            }
            .padding(.vertical, 1)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(30)
            .padding(.horizontal, 60)
            
            Text(loginMessage)
                .foregroundColor(.gray)
        }
    }
    
    func getGoogleSignInURL() async throws -> String {
        let url = URL(string: "https://musketeers-django.onrender.com/api/users/google-register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let token = AuthViewModel.retrieveToken() ?? "default_token"
        let bodyString = "token=\(token)"
        request.httpBody = bodyString.data(using: .utf8)
        
        // Perform async network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP response
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        // Parse JSON response
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let authUrl = jsonObject["auth_url"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return authUrl
    }
    
    
    func startSignInWithGoogle() {
        print("running sign in with google")
        print(googleSignInURL)
        
        guard let url = URL(string: googleSignInURL) else {
            loginMessage = "Invalid Sign-In URL"
            return
        }
        UIApplication.shared.open(url) { success in
            DispatchQueue.main.async {
                if success {
                    loginMessage = "Redirecting to Google sign-in..."
                } else {
                    loginMessage = "Failed to open URL."
                }
            }
        }
    }
}


#Preview {
    ConnectCalendarView()
}
