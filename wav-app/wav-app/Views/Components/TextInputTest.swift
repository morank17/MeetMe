//
//  TextInputTest.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 1/26/25.
//

import SwiftUI

import SwiftUI

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Username Field
            AnimatedInputField(
                text: $username,
                placeholder: "Username",
                keyboardType: .emailAddress,
                defaultValue: "Nick"
            )

            // Password Field
            AnimatedInputField(
                text: $password,
                placeholder: "Password",
                isSecure: true
            )

            // Login Button
            Button(action: handleLogin) {
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            // Additional Links
            HStack {
                Button("Forgot Password?") {
                    print("Forgot Password tapped")
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Button("Sign Up") {
                    print("Sign Up tapped")
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(edges: .all)
    }

    private func handleLogin() {
        print("Logging in with Username: \(username), Password: \(password)")
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
