//
//  PostResponse.swift
//  wav-app
//
//  Created by Matthew Kim on 1/26/25.
//

import Foundation

struct PostResponse: Decodable {
    var success: Bool
    var response: String
}

// Encodable to use in request body
struct LoginPostRequest: Encodable {
    var uname: String
    var password: String
}

// API error handling (suggestion from chatGPT)
enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(String)
}
