//
//  ConnectCalendarView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/14/24.
//

import SwiftUI

struct ConnectCalendarView: View {
    @Environment(\.presentationMode) var presentationMode // ensures that we navigate to the home page after successful account creation
    
    // this boolean will persist across app launches
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    @State private var loginMessage = "Not Logged In to Calendar"
    @State private var googleSignInURL: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Connect a Calendar Account")
                .font(.title)
                .padding()
            HStack(spacing: 30) {
                Button(action: {
                    Task {
                        do {
                            googleSignInURL = try await getGoogleSignInURL()
                            startSignInWithGoogle()
                        } catch {
                            loginMessage = "Failed to get sign-in URL. Please try again."
                            print("Error: \(error)")
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2) // Proper border with rounded corners
                            )
                        Image("GoogleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red) // Adjust for Google colors
                    }
                }
                Button(action: {
                    // connect to apple calendar
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2) // Proper border with rounded corners
                            )
                        Image("AppleIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.red) // Adjust for Google colors
                    }
                }
            }
            
            Button(action: {
                isLoggedIn.toggle() // change boolean to true so that the user stays logged in the next time they open the app
            }) {
                Text("Continue")
            }
            .padding(.vertical, 1)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                AppColors.blueGradient
            )
            .cornerRadius(30)
            .padding(.horizontal, 60)
            
            Text(loginMessage)
                .foregroundColor(.gray)
                .padding(20)
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
