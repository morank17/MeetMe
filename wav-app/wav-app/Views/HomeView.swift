//
//  HomeView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 10/30/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGray.ignoresSafeArea(.all) // Full-screen background
            
            NavigationView {
                VStack {
                    QuickJoinView()
                        .padding(.top, 20)
                    VotingProgressCarousel()
                        .padding(.top, 10)
                    JoinPeriodMeetingsCarousel()
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures full-screen VStack
                .background(AppColors.backgroundGray) // Ensures the VStack area has the same background
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures NavigationView expands
        }
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
