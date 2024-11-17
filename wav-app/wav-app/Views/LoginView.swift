//
//  LoginView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/17/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLogin: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        VStack {
            
            Text("Log In")
                .font(.title)
                .padding()
            
            TextField("Username", text: $username).padding()
            SecureField("Password", text: $password).padding()
            
            if let error = errorMessage {
                Text(error).foregroundColor(.red).padding()
            }
            
            Button(action: logIn) {
                Text("Log In")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Don't have an account? Create one.") {
                showLogin.toggle()
            }
            .padding()
        }
        .padding()
    }
    
    func logIn() {
        guard !username.isEmpty, !password.isEmpty
        else {
            errorMessage = "All Fields Are Required"
            return
        }
        
        // Call to API to create user account
        let url = URL(string: "https://musketeers-django.onrender.com/api/users/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type")
        
        print(username, password)
        let bodyString = "uname=\(username)&password=\(password)"
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
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {

                    // decode JSON response and save user token in Keychain
                    if let data = data {
                        do {
                            // Decode JSON
                            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let token = jsonObject["token"] as? String {
                                // Save the token
                                AuthViewModel.saveToken(token: token)
                                isLoggedIn.toggle()
                            } else {
                                self.errorMessage = "Token not found in response"
                            }
                        } catch {
                            self.errorMessage = "Failed to parse JSON: \(error.localizedDescription)"
                        }
                    }
                } else {
                    errorMessage = "Invalid Credentials. Please try again."
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView(showLogin: .constant(true))
}
