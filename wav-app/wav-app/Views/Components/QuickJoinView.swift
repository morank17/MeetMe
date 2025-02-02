//
//  QuickJoinView.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation
import SwiftUI

struct QuickJoinView: View {
    @State private var meetingId: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Join")
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                TextInputView(text: $meetingId, placeholder: "Meeting ID")
                    .padding(12)
                    .frame(height: 44) // Keeps height uniform
                Button(action: {
                    print("Joining meeting with ID: \(meetingId)")
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] } // Forces vertical alignment
            }
            .frame(maxWidth: .infinity) // Ensures HStack takes full width
        }
        .padding()
        .padding(.horizontal)
    }
}

struct QuickJoin_Preview: PreviewProvider {
    static var previews: some View {
        QuickJoinView()
    }
}
