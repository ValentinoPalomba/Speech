//
//  TimeFormat.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import Foundation

/// Centralised, locale-independent time formatting so the same logic is used
/// by the view model, the views and the tests.
enum TimeFormat {

    /// Formats a number of seconds as `MM:SS`, rounding up to the next whole
    /// second so a countdown shows "00:01" until it truly reaches zero.
    static func clock(seconds: Double) -> String {
        let total = Int(ceil(max(0, seconds)))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }

    static func clock(seconds: Int) -> String {
        clock(seconds: Double(seconds))
    }

    /// Formats a number of minutes as `MM:SS`.
    static func clock(minutes: Double) -> String {
        clock(seconds: minutes * 60)
    }
}
