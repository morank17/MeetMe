//
//  APIEndpoints.swift
//  wav-app
//
//  Created by Matthew Kim on 2/2/25.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://musketeers-django.onrender.com/api/"
    
    // Fetching all polls based on user token (stored from login) and pollId.
    static func fetchAllPolls(token: String) -> String {
        return "\(baseURL)polls?token=\(token)"
    }
}
