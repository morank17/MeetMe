//
//  AppColors.swift
//  wav-app
//
//  Created by Nicholas Middelberg on 11/14/24.
//

import SwiftUI

struct AppColors {
    static let blueGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cyan, Color.blue]),
        startPoint: .leading,
        endPoint: .trailing
    )
    static let gradientTypedBlack = LinearGradient(
        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.6)]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
