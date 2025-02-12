//
//  Meetings.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import Foundation

struct MeetingsResponse: Codable {
    let success: Bool
    let response: [JoinPeriodMeeting]
}

struct JoinPeriodMeeting: Identifiable, Hashable, Codable {
    var id: String { join_code }
    let title: String
    let dates_list: [String]
    let minimum_duration_in_minutes: Int
    let militime_ranges: [[String]]
    let timezone_str: String
    let max_n_victors: Int
    let join_code: String /* Join Code! */
    let participants: [String]
}
