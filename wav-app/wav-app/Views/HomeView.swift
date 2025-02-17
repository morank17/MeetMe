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
            AppColors.backgroundGray.ignoresSafeArea(.all)
            
            NavigationView {
                VStack {
                    QuickJoinView()
                        .padding(.top, 20)
                    VotingProgressCarousel()
                        .padding(.top, 10)
                    JoinPeriodMeetingsCarousel()
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.backgroundGray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
