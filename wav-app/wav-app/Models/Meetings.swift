//
//  Meetings.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import Foundation

struct JoinPeriodMeetingsResponse: Codable {
    let success: Bool
    let response: [JoinPeriodMeeting]
}

struct PollPeriodMeetingsResponse: Codable {
    let success: Bool
    let response: [PollPeriodMeeting]
}

struct MeetingInfoResponse: Codable {
    let success: Bool
    let response: MeetingInfo
}

struct JoinMeetingResponse: Codable {
    let success: Bool
    let response: JoinMeetingInfo
}

struct CompletedMeetingsResponse: Codable {
    let success: Bool
    let response: [CompletedMeeting]
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

struct PollPeriodMeeting: Identifiable, Hashable, Codable {
    var id: String { join_code }
    var title: String
    var dates_list: [String]
    var minimum_duration_in_minutes: Int
    var militime_ranges: [[String]]
    var timezone_str: String
    var max_n_victors: Int
    var join_code: String
    var participants: [String]
    var vote_status: Bool
    var poll_id: String
    var seconds_remaining: Int
}

struct MeetingInfo: Hashable, Codable {
    let title: String
    let dates_list: [String]
    let minimum_duration_in_minutes: Int
    let militime_ranges: [[String]]
    let timezone_str: String
    let max_n_victors: Int
    let join_code: String /* Join Code! */
    let participants: [String]
    let in_meeting: Bool
}

struct JoinMeetingInfo: Hashable, Codable {
    let title: String
    let dates_list: [String]
    let minimum_duration_in_minutes: Int
    let militime_ranges: [[String]]
    let timezone_str: String
    let max_n_victors: Int
    let join_code: String /* Join Code! */
    let participants: [String]
}

struct CompletedMeeting: Identifiable, Hashable, Codable {
    var id: String { join_code }
    let title: String
    let dates_list: [String]
    let minimum_duration_in_minutes: Int
    let militime_ranges: [[String]]
    let timezone_str: String
    let max_n_victors: Int
    let join_code: String /* Join Code! */
    let participants: [String]
    let winning_start_datetime: String
    let winning_end_datetime: String
    let addback: Bool
}
