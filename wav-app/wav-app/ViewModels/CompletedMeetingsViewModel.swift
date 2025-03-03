//
//  CompletedMeetingsViewModel.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/24/25.
//

import SwiftUI

class CompletedMeetingsViewModel: ObservableObject {
    @Published var completedMeetings: [CompletedMeeting] = []
    private let fetcher = CalendarFetcher()

    // Get the completed meetings
    @MainActor
    func fetchCompletedMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // fetchCompletedMeetings defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.fetchCompletedMeetings(token: token)) else {
            print("Invalid URL for fetchCompletedMeetings")
            return
        }
        
        do {
            let response: CompletedMeetingsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: CompletedMeetingsResponse.self
            )
            if response.success {
                print("Completed Meetings Loaded: \(response.response)")
                self.completedMeetings = response.response
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func declineMeeting(joinCode: String) async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // archiveMeeting defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.archiveMeeting(token: token, join_code: joinCode)) else {
            print("Invalid URL for archiveMeeting")
            return
        }
        
        do {
            let response: ArchiveMeetingResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: ArchiveMeetingResponse.self
            )
            if response.success {
                await fetchCompletedMeetings() // reload completed meetings
            } else {
                print("Failed to archive meeting")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func acceptMeeting(title: String,
                       winningStartDateTime: String,
                       winningEndDateTime: String,
                       timeZoneStr: String,
                       participants: [String],
                       loginCode: String) async {
        await fetcher.createAppleEvent(title: title, winningStartDateTime: winningStartDateTime, winningEndDateTime: winningEndDateTime, timeZoneStr: timeZoneStr, participants: participants, loginCode: loginCode)
        await fetchCompletedMeetings()
    }
}

