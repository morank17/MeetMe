//
//  PendingMeetingsViewModel.swift
//  wav-app
//
//  Created by Matthew Kim on 2/5/25.
//

import SwiftUI

// Note: PendingMeeting is the same as JoinPeriodMeeting on Backend.j
class PendingMeetingsViewModel: ObservableObject {
    // JoinPeriodMeeting & PollPeriodMeeting comes from ./Models/Meetings
    @Published var joinPeriodMeetings: [JoinPeriodMeeting] = []
    @Published var pollPeriodMeetings: [PollPeriodMeeting] = []
    @Published var meetingInfo: MeetingInfo? = nil
    @Published var joinMeetingInfo: JoinMeetingInfo? = nil
    
    // Get the join period meetings
    @MainActor
    func fetchJoinPeriodMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // fetchPendingMeetings defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.fetchJoinPeriodMeetings(token: token)) else {
            print("Invalid URL for fetchJoinPeriodMeetings")
            return
        }
        
        do {
            let response: JoinPeriodMeetingsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: JoinPeriodMeetingsResponse.self
            )
            if response.success {
                print("Join Period Meetings Loaded: \(response.response)")
                self.joinPeriodMeetings = response.response // assigning the response to the model JoinPeriodMeeting
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    // Get the poll period meetings
    @MainActor
    func fetchPollPeriodMeetings() async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // fetchPendingMeetings defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.fetchPollPeriodMeetings(token: token)) else {
            print("Invalid URL for fetchPollPeriodMeetings")
            return
        }
        
        do {
            let response: PollPeriodMeetingsResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: PollPeriodMeetingsResponse.self
            )
            if response.success {
                print("Poll Period Meetings Loaded: \(response.response)")
                self.pollPeriodMeetings = response.response // assigning the response to the model JoinPeriodMeeting
            } else {
                print("Failed to load polls")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchMeetingInfo(join_code: String) async {
       guard let token = AuthViewModel.retrieveToken() else {
           print("No token found")
           return
       }

       guard let url = URL(string: APIEndpoints.fetchMeetingInfo(token: token, join_code: join_code)) else {
           print("Invalid URL for fetchMeetingInfo")
           return
       }

       do {
           let response: MeetingInfoResponse = try await APICall.request(
               url: url,
               method: "GET",
               responseType: MeetingInfoResponse.self
           )

           if response.success {
               print("MeetingInfo Loaded: \(response.response)")
               self.meetingInfo = response.response
           } else {
               print("Failed to load meeting info")
           }
       } catch {
           print("Error decoding JSON: \(error.localizedDescription)")
       }
    }
    @MainActor
    func joinMeeting(join_code: String) async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        guard let url = URL(string: APIEndpoints.joinMeeting()) else {
            print("Invalid URL for joinMeeting")
            return
        }
        
        let requestBody: [String: Any] = [
            "token": token,
            "join-code": join_code
        ]
        print(requestBody)
        
        do {
            // convert to JSON
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let response: JoinMeetingResponse = try await APICall.request(
                url: url,
                method: "POST",
                headers: ["Content-Type": "application/json"],
                body: jsonData,
                responseType: JoinMeetingResponse.self
            )
            if response.success {
                print("MeetingInfo Loaded: \(response.response)")
                self.joinMeetingInfo = response.response
            } else {
                print("Failed to load meeting info")
            }
        } catch {
            print("Error decoding JSON pendingmeetings: \(error.localizedDescription)")
        }
    }
    @MainActor
    func endJoinPeriod(joinCode: String) async {
        guard let token = AuthViewModel.retrieveToken() else {
            print("No token found")
            return
        }
        
        // archiveMeeting defined in ./Models/APIEndpoints
        guard let url = URL(string: APIEndpoints.endJoinPeriod(token: token, join_code: joinCode)) else {
            print("Invalid URL for archiveMeeting")
            return
        }
        
        do {
            let response: ChangeMeetingPeriodResponse = try await APICall.request(
                url: url,
                method: "GET",
                responseType: ChangeMeetingPeriodResponse.self
            )
            if response.success {
                await fetchJoinPeriodMeetings() // reload completed meetings
                await fetchPollPeriodMeetings()
            } else {
                print("Failed to move meeting out of join period")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func reloadHomeView() async {
        print("Reloading Home Page...") // Debugging
        await fetchJoinPeriodMeetings()
        await fetchPollPeriodMeetings()
    }
 }
