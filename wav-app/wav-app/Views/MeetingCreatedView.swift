//
//  MeetingCreatedView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/12/25.
//

import SwiftUI

struct MeetingCreatedView: View {
    @ObservedObject var viewModel: NewMeetingViewModel
    @Binding var currentPage: Int
    @State private var showCopiedMessage = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGray
                .ignoresSafeArea()
            
            VStack {
                Text("🎉 Your meeting invite was created!")
                    .font(TextStyles.heading)
                    .foregroundStyle(AppColors.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 100)
                
                HStack {
                    if let joinCode = viewModel.joinCode {
                        Text("Join Code: \(joinCode)")
                            .font(TextStyles.subheading)
                            .foregroundStyle(AppColors.white)
                            .frame(alignment: .center)
                    } else {
                        Text("Fetching join code...")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = viewModel.joinCode
                        showCopiedMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopiedMessage = false
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                if showCopiedMessage {
                    Text("Copied to clipboard!")
                        .font(.caption)
                        .foregroundColor(.green)
                        .transition(.opacity)
                        .padding(.top, 5)
                }
                

                Button(action: {
                    viewModel.resetFields()
                    currentPage = 0
                }) {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: 172)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 90)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    struct MeetingCreatedView_PreviewWrapper: View {
        @StateObject private var viewModel = NewMeetingViewModel()
        @State private var currentPage = 1 // Mock current page
        
        var body: some View {
            MeetingCreatedView(viewModel: viewModel, currentPage: $currentPage)
                .onAppear {
                    viewModel.joinCode = "ABCD1234" // Mock join code
                }
        }
    }
    
    return MeetingCreatedView_PreviewWrapper()
}
