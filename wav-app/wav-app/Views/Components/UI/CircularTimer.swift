//
//  CircularTimer.swift
//  wav-app
//
//  Created by Matthew Kim on 2/13/25.
//

import SwiftUI

struct CircularProgressView: View {
    /// Fraction of progress from 0.0 to 1.0
    var progress: CGFloat
    
    /// Time remaining text (e.g., "2:05")
    var timeText: String
    
    /// Whether the user has voted
    var hasVoted: Bool
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: 12)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // Foreground progress circle (trims the stroke from 0 to progress)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: -90)) // Rotate so it starts at top
            
            // Centered countdown text
            VStack(spacing: 2) {
                Text(timeText) // Shows remaining time
                    .font(TextStyles.subheading)
                    .foregroundColor(.white)
                    .opacity(hasVoted ? 0.3 : 1.0) // Reduce opacity when voted
                Text("remaining") // Static text
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.7))
                    .opacity(hasVoted ? 0.3 : 1.0) // Reduce opacity when voted
            }
            
            // Checkmark badge (only shown if hasVoted == true)
            if hasVoted {
                Circle()
                    .fill(Color.green)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12)
                    )
                    .offset(x: 45, y: -45) // Adjusts position to top-right
            }
        }
        .frame(width: 114, height: 114) // Figma dimensions
    }
}

struct TestingView: View {
    @State private var remainingSeconds: Int = 125
    @State private var progress: CGFloat = 1.0
    @State private var hasVoted: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            CircularProgressView(
                progress: progress,
                timeText: String(format: "%d:%02d", remainingSeconds / 60, remainingSeconds % 60),
                hasVoted: hasVoted
            )
            
            Text("basketball ...")
                .font(.headline)
                .foregroundColor(.white)
                .opacity(hasVoted ? 0.3 : 1.0) // Reduce opacity when voted
            
            Button(action: {
                hasVoted.toggle()
            }) {
                Text(hasVoted ? "Revoke Vote" : "Vote Now")
            }
        }
        .onReceive(timer) { _ in
            guard remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            withAnimation(.linear(duration: 1)) {
                progress = CGFloat(remainingSeconds) / 125.0
            }
        }
        .padding()
    }
}


struct CircularTimer_Preview: PreviewProvider {
    static var previews: some View {
        TestingView()
            .background(AppColors.backgroundGray)
    }
}
