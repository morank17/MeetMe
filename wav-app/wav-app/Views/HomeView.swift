//
//  HomeView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 10/30/24.
//

import SwiftUI

struct HomeView: View {
    @State private var path: [Destination] = [] //holds navigation data

    var body: some View {
        ZStack {
            AppColors.backgroundGray.ignoresSafeArea(.all)
            
            NavigationStack(path: $path) {
                VStack {
                    QuickJoinView(path: $path)
                        .padding(.top, 20)
                    VotingProgressCarousel(path: $path)
                        .padding(.top, 10)
                    JoinPeriodMeetingsCarousel()
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.backgroundGray)
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .acceptMeeting(let joinCode):
                        AcceptMeetingView(join_code: joinCode)
                    case .voting(let pollId):
                        VotingView(pollId: pollId)
                    }
                }
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
