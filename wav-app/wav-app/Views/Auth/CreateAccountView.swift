//
//  CreateAccountView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/27/24.
//

import SwiftUI

struct User: Codable {
    let uname: String
    let email: String
    let password1: String
    let password2: String
}

struct CreateAccountView: View {
    @Binding var showLogin: Bool

    
    // user input state variables
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var errorMessage: String?  // Display error messages
    @State private var navigateToCalendar = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Account")
                    .font(.title)
                    .padding()
                
                // user input fields
                TextField("Username", text: $username)
                    .padding()
                TextField("Email", text: $email)
                    .padding()
                SecureField("Password1", text: $password1)
                    .padding()
                SecureField("Password2", text: $password2)
                    .padding()
                
                // display error message if there is one
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // create account button
                Button(action: {
                    createAccount()
                }) {
                    Text("Create Account")
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
                
                Button("Already have an account? Log in.") {
                    showLogin.toggle()
                }
                .navigationDestination(isPresented: $navigateToCalendar) {
                    ConnectCalendarView()
                }
            }
        }
    }
    
    // helper function called by create account button
    func createAccount() {
        guard !username.isEmpty, !password1.isEmpty, !email.isEmpty, !password2.isEmpty else {
            errorMessage = "All Fields Are Required"
            return
        }
        
        // Call to API to create user account
        let url = URL(string: "https://musketeers-django.onrender.com/api/users/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type")
        
        let bodyString = "uname=\(username)&email=\(email)&password1=\(password1)&password2=\(password2)"
        request.httpBody = bodyString.data(using: .utf8)
        
        // initiate asynch network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in DispatchQueue.main.async {
                // check connection to API
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
            
                // print statements for testing
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
            
                if let data = data {
                    // Convert data to a string for debugging
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received data: \(jsonString)")
                    }
                }
            
                // check for valid API response indicating a new user profile was made
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {

                    // decode JSON response and save user token in Keychain
                    if let data = data {
                        do {
                            // Decode JSON
                            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let token = jsonObject["token"] as? String {
                                // Save the token
                                AuthViewModel.saveToken(token: token)
                                navigateToCalendar = true
                            } else {
                                self.errorMessage = "Token not found in response"
                            }
                        } catch {
                            self.errorMessage = "Failed to parse JSON: \(error.localizedDescription)"
                        }
                    }
                } else {
                    errorMessage = "Failed to create account. Please try again."
                }
            }
        }.resume()
    }
}

#Preview {
    CreateAccountView(showLogin: .constant(true))
}
