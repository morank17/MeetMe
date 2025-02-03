//
//  VotingProgressCarousel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation
import SwiftUI

struct VotingProgressCarousel: View {
    @StateObject private var viewModel = VotingProgressViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Voting In Progress")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if viewModel.polls.isEmpty {
                        // Placeholder views while loading
                        ForEach(0..<3, id: \.self) { _ in
                            PlaceholderVotingIconView()
                        }
                    } else {
                        ForEach(viewModel.polls) { poll in
                            VotingIconView(details: poll)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchVotingProgress()
            }
        }
    }
}


struct VotingIconView: View {
    let details: Poll
    
    var body: some View {
        VStack {
            Image(systemName: details.is_closed ? "checkmark.circle.fill" : "clock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(details.is_closed ? .blue : .gray)

            Text(details.title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 80)
    }
}

// Placeholder while loading
struct PlaceholderVotingIconView: View {
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

// MARK: - Preview
struct VotingProgressCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VotingProgressCarousel()
    }
}
