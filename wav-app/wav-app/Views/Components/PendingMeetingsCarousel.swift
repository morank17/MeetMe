//
//  PendingMeetingsCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI
import Foundation

struct PendingMeetingsCarousel: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pending Meetings")
                .font(TextStyles.subheading)
                .foregroundColor(.white)
                .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    if viewModel.meetings.isEmpty {
                        // Places 1 placeholder view icon
                        ForEach(0..<3, id: \.self) { _ in
                            PlaceholderPendingMeetingsTab()
                        }
                    } else {
                        ForEach(viewModel.meetings) { meeting in
                            PendingMeetingsTab(details: meeting)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPendingMeetings()
            }
        }
    }
}

struct PendingMeetingsTab: View {
    let details: Meetings
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 10)
        }
        .frame(width: 80)
    }
}

struct PlaceholderPendingMeetingsTab: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 50)

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PendingMeetingsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        PendingMeetingsCarousel()
            .background(AppColors.backgroundGray)
    }
}
