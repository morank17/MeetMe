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
    static func fetchAllPolls(token: String) -> String {
        return "\(baseURL)polls?token=\(token)"
    }
    
    // fetching all meetings that have not been set (not all participants have joined) based on user token stored from login).
    static func fetchPendingMeetings(token: String) -> String {
        return "\(baseURL)meetings?token=\(token)"
    }
}
