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
        
        ZStack {
            
            Color(AppColors.backgroundGray).edgesIgnoringSafeArea(.all) // Dark background color
            
            VStack {
                
                Text("Welcome Back!")
                    .font(TextStyles.heading)
                    .padding(.vertical)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Username")
                    .foregroundColor(AppColors.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                TextField("", text: $username)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.textBlockGray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                Text("Password")
                    .foregroundColor(AppColors.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("", text: $password).padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.textBlockGray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                if let error = errorMessage {
                    Text(error).foregroundColor(.red).padding()
                }
                Spacer().frame(height: 100)
                Button(action: logIn) {
                    Text("Log In")
                    
                }
                .padding()
                .frame(width: 200, height: 75)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                HStack(spacing: 1) {
                    
                    Text("Don't have an account?")
                        .foregroundColor(Color.white)
                        
                    
                    Button(" Sign Up") {
                        showLogin.toggle()
                    }
                    .padding()
                    .padding(.horizontal, -15)
                    
                    
                }
                
               
                
                Spacer()
                    .frame(height: 100)
            }
            .padding()

        }
        
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
