//
//  CompletedMeetingsView.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/24/25.
//

import SwiftUI

struct CompletedMeetingsView: View {
    @StateObject private var viewModel = CompletedMeetingsViewModel()
    
    
    var body: some View {
        VStack {
            Text("Completed Meetings")
                .font(TextStyles.heading)
                .foregroundStyle(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    if viewModel.completedMeetings.isEmpty {
                        // Places 1 placeholder view icon
                        ForEach(0..<5, id: \.self) { _ in
                            PlaceholderPendingMeetingsTab()
                        }
                    } else {
                        ForEach(viewModel.completedMeetings.filter { $0.addback }) { meeting in
                            CompletedMeetingsTab(details: meeting, viewModel: viewModel)
                        }
                    }
                }
            }

        }
        .padding(.top, 90)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(AppColors.backgroundGray)

    }
}

struct CompletedMeetingsTab: View {
    let details: CompletedMeeting
    @ObservedObject var viewModel: CompletedMeetingsViewModel
    
    var body: some View {
        ZStack {
            // Background Rectangle
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 80)
            HStack {
                VStack {
                    Text(details.title.truncated(to: 35)) // Limits meetingName to 20 characters
                        .font(TextStyles.nonboldlarge)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    Spacer().frame(height: 7)
                    
                    Text(formatDateRange(start: details.winning_start_datetime, end: details.winning_end_datetime))
                        .font(TextStyles.selectionlabel)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                Button(action: viewModel.declineMeeting) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
                
                Button(action: viewModel.acceptMeeting) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            
        }
        .frame(maxWidth: .infinity)
    }
    private func formatDateRange(start: String, end: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        guard let startDate = dateFormatter.date(from: start),
              let endDate = dateFormatter.date(from: end) else {
            return "Invalid date"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd/yy h:mm a"
        
        return "\(displayFormatter.string(from: startDate)) - \(displayFormatter.string(from: endDate))"
    }
}


//#Preview {
//    CompletedMeetingsView()
//}
//
//#Preview {
//    let mockMeeting = CompletedMeeting(
//        title: "from-setup-to-endjoin",
//        dates_list: [
//            "2025-02-08",
//            "2025-02-09"
//        ],
//        minimum_duration_in_minutes: 60,
//        militime_ranges: [["06:00"],["14:00"],["18:00"],["19:59"]],
//        timezone_str: "-05:00",
//        max_n_victors: 10,
//        join_code: "6N5-WGX",
//        participants: [
//            "ttest1",
//            "laptttop"
//        ],
//        winning_start_datetime: "2025-02-09T09:00:00Z",
//        winning_end_datetime: "2025-02-09T10:00:00Z",
//        addback: false
//                
//
//    )
//    
//    VStack {
//        CompletedMeetingsTab(details: mockMeeting)
//            .padding()
//            .background(Color.black) // Helps visibility in preview
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(AppColors.backgroundGray)
//}
