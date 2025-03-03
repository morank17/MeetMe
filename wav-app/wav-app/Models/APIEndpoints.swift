//
//  APIEndpoints.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://musketeers-django.onrender.com/api/"
    
    // Fetching all polls based on user token (stored from login).
    static func fetchPollPeriodMeetings(token: String) -> String {
        return "\(baseURL)polls?token=\(token)"
    }
    
    // fetching all meetings that have not been set (not all participants have joined) based on user token stored from login).
    static func fetchJoinPeriodMeetings(token: String) -> String {
        return "\(baseURL)meetings?token=\(token)"
    }
    
    // Fetching all polls based on user token (stored from login).
    static func fetchMeetingInfo(token: String, join_code: String) -> String {
        return "\(baseURL)meetings/info?token=\(token)&joincode=\(join_code)"
    }
    
    // Fetching all completed meetings based on user token
    static func fetchCompletedMeetings(token: String) -> String {
        return "\(baseURL)meetings/fetch-confirm-mtgs?token=\(token)"
    }
    
    static func fetchPollOptions(token: String, poll_id: String) -> String {
        return "\(baseURL)polls/options?token=\(token)&poll_id=\(poll_id)"
    }
    
    static func votePoll() -> String {
        return "\(baseURL)polls/vote"
    }
    
    // add user to proposed meeting
    static func joinMeeting() -> String {
        return "\(baseURL)meetings/join"
    }
    
    static func archiveMeeting(token: String, join_code: String) -> String {
        return "\(baseURL)meetings/archive?token=\(token)&join-code=\(join_code)"
    }
    
}
