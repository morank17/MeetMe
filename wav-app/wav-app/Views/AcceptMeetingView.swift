//
//  AcceptMeetingView.swift
//  wav-app
//
//  Created by Romeo Myrthil on 2/16/25.
//
    
import Foundation
import SwiftUI

struct AcceptMeetingView: View {
    @StateObject private var viewModel = PendingMeetingsViewModel()
    var join_code: String

    var body: some View {
        ZStack {
            AppColors.backgroundGray
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Join Meeting")
                    .font(TextStyles.heading)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
               
                HStack(spacing: 20) {
                    Button(action: {
                        // Deny action
                    }) {
                        Text("Deny")
                            .foregroundColor(.red)
                            .frame(width: 170, height: 75)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 3)
                            )
                    }
                    
                    Button(action: {
                        // Accept action
                    }) {
                        Text("Accept")
                            .foregroundColor(.white)
                            .frame(width: 170, height: 75)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.vertical, 50)
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMeetingInfo(join_code: join_code)
            }
        }
        .navigationTitle("Accept Meeting")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// This function returns a tuple with the first and last indices of dates_list,
// or nil if the list is empty.
func firstAndLastIndices(from dates_list: [String]) -> (firstIndex: Int, lastIndex: Int)? {
    guard !dates_list.isEmpty else {
        return nil
    }
    return (0, dates_list.count - 1)
}

#Preview {
    AcceptMeetingView(join_code: "6D2-GOF")
}
