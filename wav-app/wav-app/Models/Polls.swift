//
//  Poll.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/19/24.
//

import Foundation

struct Poll: Identifiable, Hashable, Codable {
    var id: String { poll_id }
    var poll_id: String
    var title: String
//    var is_closed: Bool
    var votes_cast: Int
    var number_of_attendees: Int
//    var final_start_time: String?
//    var final_end_time: String?
    
    // reformat fraction of attendees who have voted
    var voteFraction: String {
        let fraction = Double(votes_cast) / Double(number_of_attendees)
        return String(format: "%.0f%%", fraction * 100)
    }
    
    // reformat date from final_start_time and final_end_time
//    var formattedDate: String? {
//        guard let startTime = final_start_time else { return nil }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = formatter.date(from: startTime) {
//            formatter.dateFormat = "dd/MM/yy"
//            return formatter.string(from: date)
//        }
//        return nil
//    }
//    
//    // reformat time interval of meeting
//    var formattedTime: String? {
//        guard let startTime = final_start_time, let endTime = final_end_time else { return nil }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let start = formatter.date(from: startTime), let end = formatter.date(from: endTime) {
//            formatter.dateFormat = "h:mm a"
//            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
//        }
//        return nil
//    }
}

struct PollsResponse: Codable {
    let success: Bool
    let response: [Poll]
}

struct PollOption: Identifiable, Codable {
    var id: String { poll_option_id }
    let poll_option_id: String
    let start_time: String
    let end_time: String
    let number_of_votes: Int
    
    // Reformat date from start_time
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: start_time) {
            formatter.dateFormat = "EEEE, dd/MM/yy"
            return formatter.string(from: date)
        }
        return "Invalid Date"
    }
    
    // Reformat time interval of meeting
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let start = formatter.date(from: start_time), let end = formatter.date(from: end_time) {
            formatter.dateFormat = "h:mm a"
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
        return "Invalid Time"
    }
}

struct PollOptionResponse: Decodable {
    let success: Bool
    let response: [PollOption]
}

struct PollVotePostJSON: Codable {
    let token: String
    let poll_option_id: String
}
