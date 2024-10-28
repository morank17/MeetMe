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

#Preview {
    HomeView()
}
