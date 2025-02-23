//
//  ConnectCalendarView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 12/15/2024
//
import SwiftUI
import EventKit

struct ConnectCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var loginMessage = "Not Logged In to Calendar"
    @State private var googleSignInURL: String = ""
    @State private var navigateToHome = false
    private let fetcher = CalendarFetcher()

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Connect a Calendar Account")
                    .font(.title)
                    .padding()

                HStack(spacing: 30) {
                    // Google Sign-In Button
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
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            Image("GoogleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }

                    // Apple Calendar Button - Requests Full Access
                    Button(action: {
                        Task {
                            let accessGranted = await fetcher.requestFullCalendarAccess()
                            DispatchQueue.main.async {
                                loginMessage = accessGranted ? "Connected to Apple Calendar ✅" : "Access Denied ❌"
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                            Image("AppleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                        }
                    }
                }

                // Continue Button (Navigates to HomeView)
                Button(action: {
                    isLoggedIn = true
                    navigateToHome = true
                }) {
                    Text("Continue")
                }
                .padding(.vertical, 1)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.blueGradient)
                .cornerRadius(30)
                .padding(.horizontal, 60)

                // Display Login Message
                Text(loginMessage)
                    .foregroundColor(.gray)
                    .padding(20)
            }
            .onAppear {
                Task {
                    await checkAppleCalendarAccess()
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }


    /// Checks Apple Calendar access
    func checkAppleCalendarAccess() async {
        let status = EKEventStore.authorizationStatus(for: .event)

        DispatchQueue.main.async {
            if status == .fullAccess {
                loginMessage = "Connected to Apple Calendar ✅"
            } else {
                loginMessage = "Not Logged In to Calendar ❌"
            }
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

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }

        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let authUrl = jsonObject["auth_url"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        return authUrl
    }

    func startSignInWithGoogle() {
        print("Running sign-in with Google")
        print(googleSignInURL)
        guard let url = URL(string: googleSignInURL) else {
            loginMessage = "Invalid Sign-In URL"
            return
        }
        UIApplication.shared.open(url) { success in
            DispatchQueue.main.async {
                loginMessage = success ? "Redirecting to Google sign-in..." : "Failed to open URL."
            }
        }
    }
}

#Preview {
    ConnectCalendarView()
}

