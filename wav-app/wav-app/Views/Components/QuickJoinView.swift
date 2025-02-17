//
//  QuickJoinView.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import SwiftUI

struct QuickJoinView: View {
    @State private var join_code: String = ""
    @State private var isNavigating: Bool = false
    
    var body: some View {
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
                    isNavigating = true  // Trigger navigation
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
            
            // Hidden NavigationLink that navigates to AcceptMeetingView
            NavigationLink(
                destination: AcceptMeetingView(join_code: join_code),
                isActive: $isNavigating,
                label: { EmptyView() }
            )
            .hidden()
        }
        .padding(.horizontal, 16)
    }
}

struct QuickJoinView_Previews: PreviewProvider {
    static var previews: some View {
        QuickJoinView()
            .background(AppColors.backgroundGray)
    }
}
