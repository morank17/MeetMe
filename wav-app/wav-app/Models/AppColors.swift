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
    static let backgroundGray = Color(
        red: 33 / 255.0,
        green: 40 / 255.0,
        blue: 50 / 255.0
    )
    
    static let backgroundLighterGray = Color(
        red: 66 / 255.0,
        green: 80 / 255.0,
        blue: 100 / 255.0
    )
    
    static let white = Color(
        red: 243 / 255.0,
        green: 243 / 255.0,
        blue: 243 / 255.0
    )
    static let highlightBlue = Color(
        red: 79 / 255.0,
        green: 144 / 255.0,
        blue: 240 / 255.0
    )
    static let textGray = Color(
        red: 156 / 255.0,
        green: 156 / 255.0,
        blue: 156 / 255.0
    )
    static let textBlockGray = Color(
        red: 69 / 255.0,
        green: 90 / 255.0,
        blue: 100 / 255.0
    )
}
