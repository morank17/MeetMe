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
    // this boolean will persist across app launches
    @AppStorage("hasAccount") var hasAccount: Bool = false

    @Environment(\.presentationMode) var presentationMode // ensures that we navigate to the home page after successful account creation
    
    // user input state variables
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var errorMessage: String?  // Display error messages to help user
    
    var body: some View {
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
//                fetchCSRFToken { csrfToken in
//                    if let token = csrfToken {
//                        createAccount(with: token)
//                    } else {
//                        print("Failed to retrieve CSRF token")
//                    }
//                }
            }) {
                Text("Create Account")
            }
        }
    }
    
//    func fetchCSRFToken(completion: @escaping (String?) -> Void) {
//        guard let url = URL(string: "http://127.0.0.1:8000/") else { return }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let httpResponse = response as? HTTPURLResponse,
//               let csrfToken = httpResponse.value(forHTTPHeaderField: "X-CSRF-Token") {  // Adjust key if necessary
//                completion(csrfToken)
//            } else {
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
//    
    // helper function called by create account button
    func createAccount() {
        guard !username.isEmpty, !password1.isEmpty, !email.isEmpty, !password2.isEmpty else {
            errorMessage = "All Fields Are Required"
            return
        }
        
        // Call to API to create user account
        let url = URL(string: "https://musketeers-django.onrender.com/api/register")!
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
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Response status code: \(httpResponse.statusCode)")
//                }
//            
//                if let data = data {
//                    // Convert data to a string for debugging
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("Received data: \(jsonString)")
//                    }
//                }
            
                // check for valid API response indicating a new user profile was made
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
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
