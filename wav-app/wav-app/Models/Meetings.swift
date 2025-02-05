//
//  Meetings.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import Foundation

struct Meetings: Identifiable, Hashable, Codable {
    var id: String { meeting_id }
    let meeting_id: String
    let start_time: String
    let end_time: String
    let meeting_pending: Bool
}

struct MeetingsResponse: Codable {
    let success: Bool
    let response: [Meetings]
}
