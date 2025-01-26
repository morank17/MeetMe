//
//  OnboardingView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/17/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showLogin: Bool = true // Toggle between login and create account
    
    var body: some View {
        NavigationStack {
            VStack {
                if showLogin {
                    LoginView(showLogin: $showLogin)
                } else {
                    CreateAccountView(showLogin: $showLogin)
                }
            }
//            .navigationTitle(showLogin ? "Log In" : "Create Account")
        }
    }
}


#Preview {
    OnboardingView()
}
