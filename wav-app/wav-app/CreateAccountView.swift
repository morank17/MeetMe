//
//  CreateAccountView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/27/24.
//

import SwiftUI

struct User: Codable {
    let username: String
    let password: String
}

struct CreateAccountView: View {
    // this boolean will persist across app launches
    @AppStorage("hasAccount") var hasAccount: Bool = false

    @Environment(\.presentationMode) var presentationMode // ensures that we navigate to the home page after successful account creation
    
    // user input state variables
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?  // Display error messages to help user
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.title)
                .padding()
            
            // user input fields
            TextField("Username", text: $username)
                .padding()
            SecureField("Password", text: $password)
                .padding()
            
            // display error message if there is one
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // create account button
            Button(action: {
                
            }) {
                Text("Create Account")
            }
        }
    }
    
    // helper function called by create account button
    func createAccount() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Both Fields Are Required"
            return
        }
        
        // Call to API to create user account
        let url = URL(string: "https://example.com/api/createAccount")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(username: username, password: password)
        guard let body = try? JSONEncoder().encode(user) else {
            errorMessage = "Failed to encode user data."
            return
        }
        request.httpBody = body // set content of request to newly defined body
        
        // initiate asynch network request to the API
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // check connection to API
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                // check for valid API response indicating a new user profile was made
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    hasAccount.toggle() // change boolean to true so that the user stays logged in the next time they open the app
                } else {
                    errorMessage = "Failed to create account. Please try again."
                }
            }
        }.resume()
    }
}

#Preview {
    CreateAccountView()
}
