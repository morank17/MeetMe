//
//  TextStyles.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 1/30/25.
//

import SwiftUI

struct TextStyles {
    static let heading = Font.system(
        size: 27,
        weight: .bold
    )
    static let subheading = Font.system(
        size: 24,
        weight: .semibold
    )
    static let nonboldlarge = Font.system(
        size: 20,
        weight: .regular
    )
    static let text = Font.system(
        size: 16,
        weight: .regular
    )
    static let boldtext = Font.system(
        size: 16,
        weight: .bold
    )
    static let selectionlabel = Font.system(
        size: 12,
        weight: .semibold
    )
    static let selectionlabel2 = Font.system(
        size: 12,
        weight: .regular
    )
}

// Truncates string by character length
extension String {
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}
