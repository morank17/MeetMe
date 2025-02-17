//
//  QuickJoinView.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import SwiftUI

struct QuickJoinView: View {
    @State private var join_code: String = ""
    @State private var path: [String] = [] // This will hold our navigation data

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Join")
                    .font(TextStyles.subheading)
                    .foregroundColor(.white)
                Spacer().frame(height: 5) // Space for placeholder animation

                HStack {
                    TextInputView(text: $join_code, placeholder: "Meeting ID")
                        .frame(height: 44) // Keeps height uniform

                    Button(action: {
                        print("Joining meeting with ID: \(join_code)")
                        // Append the join_code to the path to trigger navigation
                        path.append(join_code)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 29, height: 29)
                    }
                    .frame(width: 58, height: 58) // Ensures square shape
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.leading, 10) // Total horizontal padding adjusted
                }
                .frame(maxWidth: .infinity) // HStack takes full width
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: String.self) { join_code in
                AcceptMeetingView(join_code: join_code)
            }
            .background(AppColors.backgroundGray)
        }
    }
}

struct QuickJoinView_Previews: PreviewProvider {
    static var previews: some View {
        QuickJoinView()
    }
}
