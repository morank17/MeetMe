//
//  AcceptMeetingView.swift
//  wav-app
//
//  Created by Romeo Myrthil on 2/16/25.
//

import Foundation
import SwiftUI

struct AcceptMeetingView: View {
    var body: some View {
            ZStack {
                AppColors.backgroundGray.edgesIgnoringSafeArea(.all)
                
                
                VStack(spacing: 50) {
                    
                    Spacer()
                    
                    Text("Join Meeting")
                        .font(TextStyles.heading)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding()
                    
                    
                    VStack(spacing: 10) {
                        Text("Kevins Acid Reflux")
                            .font(TextStyles.heading)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical)
                        
                        Text("Thur 1/27, 11am - 3pm")
                            .font(TextStyles.subheading)
                            .foregroundColor(.white)
                            .padding(.vertical)
                        
                        Text("Host: Nick")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                        
                        Text("Meeting ID: f0055hq")
                            .foregroundColor(AppColors.textGray)
                            .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 3))
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            // Deny action
                        }) {
                            Text("Deny")
                                .foregroundColor(.red)
                                .frame(width: 170, height: 75)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 3))
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
                    Spacer()
                }
            }
            .navigationTitle("Accept Meeting")
            .navigationBarTitleDisplayMode(.inline)
        }
}

#Preview {
    AcceptMeetingView()
}
