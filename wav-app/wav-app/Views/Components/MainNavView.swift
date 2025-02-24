//
//  MainNavView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 1/19/25.
//

import SwiftUI

struct MainNavView: View {
    
    init() {
        // Set the unselected tab icon and text color to white
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        
        // Set the tab bar background to a custom color (optional)
        UITabBar.appearance().backgroundColor = UIColor(AppColors.backgroundGray)
    }
    
    @State private var selectedTab = 0 // Default tab
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0)
            
            NewMeetingView()
            .tabItem {
                Image(systemName: "plus")
            }
            .tag(1)
            
            SettingsView()
            .tabItem {
                Image(systemName: "gear")
            }
            .tag(2)

        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavView()
    }
}
