//
//  VotePollButtonView.swift
//  wav-app
//
//  Created by Matthew Kim on 2/9/25.
//

import SwiftUI

struct TimeSlotView: View {
    let dateTime: String
    let votes: Int
    let isSelected: Bool
    let onPress: () -> Void  // Action to execute when tapped
    
    var body: some View {
        Button(action: {
            onPress()
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateTime)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.6)) : RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                    .shadow(color: isSelected ? Color.blue.opacity(0.8) : Color.clear, radius: 5)

                Text("\(votes) votes")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.white)
            }
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
}

struct ContentView: View {
    let dateString: String
    var body: some View {
        TimeSlotView(
            dateTime: dateString,
            votes: 3,
            isSelected: false,
            onPress: {
                print("TimeSlotView Pressed!") // Action when tapped
            }
        )
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dateString: "Sat 11/30, 11:00am - 1:00pm")
            .background(AppColors.backgroundGray)
    }
}
