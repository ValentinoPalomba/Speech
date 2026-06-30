//
//  Palette.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// The app's colour identity: pure-black canvas with a blue/cyan accent,
/// echoing the original 2020 Speech design.
enum AppColor {
    /// Primary accent — iOS system blue (#0A84FF).
    static let accent = Color(red: 0.039, green: 0.518, blue: 1.0)
    /// Lighter cyan highlight used for gradients and glows.
    static let highlight = Color(red: 0.35, green: 0.78, blue: 1.0)
    /// Canvas.
    static let background = Color.black
    /// Faint stroke for decorative, non-essential shapes.
    static let faintStroke = Color.white.opacity(0.25)
    /// Destructive actions.
    static let destructive = Color(red: 1.0, green: 0.30, blue: 0.33)
}

/// Accent colours cycled across saved-timer rows (one colour per preset).
enum TimerPalette {
    static let colors: [Color] = [
        Color(red: 0.039, green: 0.518, blue: 1.0),  // blue
        Color(red: 0.62, green: 0.40, blue: 1.0),    // purple
        Color(red: 0.20, green: 0.82, blue: 0.52),   // green
        Color(red: 1.0, green: 0.64, blue: 0.24),    // orange
        Color(red: 1.0, green: 0.40, blue: 0.60),    // pink
        Color(red: 0.20, green: 0.82, blue: 0.86),   // teal
    ]

    static var count: Int { colors.count }

    static func color(_ index: Int) -> Color {
        colors[((index % count) + count) % count]
    }
}
