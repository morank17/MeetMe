//
//  NavigationDestination.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 2/23/25.
//

import Foundation

enum Destination: Hashable {
    case acceptMeeting(joinCode: String)
    case voting(pollId: String)
}
