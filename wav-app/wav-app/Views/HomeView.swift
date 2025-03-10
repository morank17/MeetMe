//
//  HomeView.swift
//  wav-app
//
//  Created by Nikola Dimitrijevic on 10/30/24.
//

import SwiftUI

struct HomeView: View {
    @State private var path: [Destination] = [] //holds navigation data
    @StateObject private var viewModel = PendingMeetingsViewModel()
    @State private var isRefreshing = false

    
    var body: some View {
        ZStack {
            AppColors.backgroundGray.ignoresSafeArea(.all)

            NavigationStack(path: $path) {
                VStack(spacing: 10) {
                    if isRefreshing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 10)
                    }
                    QuickJoinView(viewModel: viewModel, path: $path)
                        .padding(.top, 20)

                    VotingProgressCarousel(viewModel: viewModel, path: $path)
                        .padding(.top, 10)

                    JoinPeriodMeetingsCarousel(viewModel: viewModel)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.backgroundGray)
                .simultaneousGesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height > 50 { // Detect downward swipe
                                Task {
                                    isRefreshing = true
                                    await viewModel.reloadHomeView()
                                    isRefreshing = false
                                }
                            }
                        }
                )
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .acceptMeeting(let joinCode):
                        AcceptMeetingView(path: $path, join_code: joinCode)
                    case .voting(let pollId):
                        VotingView(path: $path, pollId: pollId)
                    }
                }
                .task {
                    print("HomeView Loaded - Fetching Initial Data")
                    await viewModel.fetchJoinPeriodMeetings()
                    await viewModel.fetchPollPeriodMeetings()
                }
            }
        }
    }
}


// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
