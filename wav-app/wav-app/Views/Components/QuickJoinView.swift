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
                .font(TextStyles.subheading)
                .foregroundColor(.white)
            Spacer().frame(height: 5) // Space for placeholder animation
            HStack() {
                
                TextInputView(text: $meetingId, placeholder: "Meeting ID")
                    .frame(height: 44) // Keeps height uniform
                
                Button(action: {
                    print("Joining meeting with ID: \(meetingId)")
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 29, height: 29)
                }
                .frame(width: 58, height: 58) // Ensures square shape
                .background(Color.blue)
                // makes the shape square with corner radius.
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10) // want 18 total padding, and TextInputView default horizontal padding is 8
            }
            .frame(maxWidth: .infinity) // Ensures HStack takes full width
        }
        .padding(.horizontal, 16)
    }
}

struct QuickJoin_Preview: PreviewProvider {
    static var previews: some View {
        QuickJoinView()
        // for testing, makes the component background grey
            .background(AppColors.backgroundGray)
    }
}
