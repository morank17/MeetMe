//
//  wav_appApp.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/27/24.
//

import SwiftUI

@main
struct wav_appApp: App {
    // initialize hasAccount boolean to false when the user first opens the app
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView() // Show the home view
            } else {
                OnboardingView() // Show view to create an account
            }
        }
    }
}
