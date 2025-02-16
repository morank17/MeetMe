import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/dime/Documents/project-musketeers/wav-app/wav-app/Views/Auth/ConnectCalendarView.swift", line: 1)
//
//  ConnectCalendarView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/14/24.
// Edited by Nikola Dimitrijevic Feb 6 25

import SwiftUI
import EventKit

struct ConnectCalendarView: View {
    @Environment(\.presentationMode) var presentationMode // ensures that we navigate to the home page after successful account creation
    
    // this boolean will persist across app launches
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    @State private var loginMessage = "Not Logged In to Calendar"
    @State private var googleSignInURL: String = ""
    
    var body: some View {
        VStack(spacing: __designTimeInteger("#2754_0", fallback: 30)) {
            Text(__designTimeString("#2754_1", fallback: "Connect a Calendar Account"))
                .font(.title)
                .padding()
            HStack(spacing: __designTimeInteger("#2754_2", fallback: 30)) {
                Button(action: {
                    Task {
                        do {
                            googleSignInURL = try await getGoogleSignInURL()
                            startSignInWithGoogle()
                        } catch {
                            loginMessage = __designTimeString("#2754_3", fallback: "Failed to get sign-in URL. Please try again.")
                            print("Error: \(error)")
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: __designTimeInteger("#2754_4", fallback: 10))
                            .fill(Color.white)
                            .frame(width: __designTimeInteger("#2754_5", fallback: 100), height: __designTimeInteger("#2754_6", fallback: 100))
                            .overlay(
                                RoundedRectangle(cornerRadius: __designTimeInteger("#2754_7", fallback: 10))
                                    .stroke(Color.black, lineWidth: __designTimeInteger("#2754_8", fallback: 2)) // Proper border with rounded corners
                            )
                        Image(__designTimeString("#2754_9", fallback: "GoogleIcon"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: __designTimeInteger("#2754_10", fallback: 50), height: __designTimeInteger("#2754_11", fallback: 50))
                            .foregroundColor(.red) // Adjust for Google colors
                    }
                }
                Button(action: {
                    // connect to apple calendar
                    let fetcher = CalendarFetcher()
                    Task {
                        await fetcher.requestAndFetchEvents()
                                        }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: __designTimeInteger("#2754_12", fallback: 10))
                            .fill(Color.white)
                            .frame(width: __designTimeInteger("#2754_13", fallback: 100), height: __designTimeInteger("#2754_14", fallback: 100))
                            .overlay(
                                RoundedRectangle(cornerRadius: __designTimeInteger("#2754_15", fallback: 10))
                                    .stroke(Color.black, lineWidth: __designTimeInteger("#2754_16", fallback: 2)) // Proper border with rounded corners
                            )
                        Image(__designTimeString("#2754_17", fallback: "AppleIcon"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: __designTimeInteger("#2754_18", fallback: 45), height: __designTimeInteger("#2754_19", fallback: 45))
                            .foregroundColor(.red) // Adjust for Google colors
                    }
                }
            }
            
            Button(action: {
                isLoggedIn.toggle() // change boolean to true so that the user stays logged in the next time they open the app
            }) {
                Text(__designTimeString("#2754_20", fallback: "Continue"))
            }
            .padding(.vertical, __designTimeInteger("#2754_21", fallback: 1))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                AppColors.blueGradient
            )
            .cornerRadius(__designTimeInteger("#2754_22", fallback: 30))
            .padding(.horizontal, __designTimeInteger("#2754_23", fallback: 60))
            
            Text(loginMessage)
                .foregroundColor(.gray)
                .padding(__designTimeInteger("#2754_24", fallback: 20))
        }
    }
    
    func getGoogleSignInURL() async throws -> String {
        let url = URL(string: __designTimeString("#2754_25", fallback: "https://musketeers-django.onrender.com/api/users/google-register"))!
        var request = URLRequest(url: url)
        request.httpMethod = __designTimeString("#2754_26", fallback: "POST")
        request.setValue(__designTimeString("#2754_27", fallback: "application/x-www-form-urlencoded"), forHTTPHeaderField: __designTimeString("#2754_28", fallback: "Content-Type"))
        
        let token = AuthViewModel.retrieveToken() ?? __designTimeString("#2754_29", fallback: "default_token")
        let bodyString = "token=\(token)"
        request.httpBody = bodyString.data(using: .utf8)
        
        // Perform async network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP response
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != __designTimeInteger("#2754_30", fallback: 200) {
            throw URLError(.badServerResponse)
        }
        
        // Parse JSON response
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let authUrl = jsonObject[__designTimeString("#2754_31", fallback: "auth_url")] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return authUrl
    }
    
    
    func startSignInWithGoogle() {
        print(__designTimeString("#2754_32", fallback: "running sign in with google"))
        print(googleSignInURL)
        
        guard let url = URL(string: googleSignInURL) else {
            loginMessage = __designTimeString("#2754_33", fallback: "Invalid Sign-In URL")
            return
        }
        UIApplication.shared.open(url) { success in
            DispatchQueue.main.async {
                if success {
                    loginMessage = __designTimeString("#2754_34", fallback: "Redirecting to Google sign-in...")
                } else {
                    loginMessage = __designTimeString("#2754_35", fallback: "Failed to open URL.")
                }
            }
        }
    }
}


#Preview {
    ConnectCalendarView()
}
