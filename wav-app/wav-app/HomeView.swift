//
//  ContentView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 10/27/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View { // all visual elements to be rendered must be in body
        NavigationView {
            VStack {
                Text("Home Page")
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    // Action to perform when the button is tapped
                    print("Button tapped!")
                }) {
                    NavigationLink(destination: NewMeetingView()) {
                        Text("Start New Meeting")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
