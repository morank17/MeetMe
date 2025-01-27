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
        
        let bodyString = "uname=\(username)&password=\(password)" // URL-encoded string
        let body = bodyString.data(using: .utf8)
        
        // Call to API to create user account
        guard let url = URL(string: "https://musketeers-django.onrender.com/api/users/login") else {
            print("Invalid URL")
            return
        }
        
        // Call APICall with a POST request
        APICall.shared.loginRequest(
            url: url,
            method: "POST",
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            body: body // URL-encoded body
        )
    }
}

#Preview {
    LoginView(showLogin: .constant(true))
}
