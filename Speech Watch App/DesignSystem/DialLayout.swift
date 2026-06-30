//
//  DialLayout.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

extension View {
    /// Positions the view on a circle of `radius`, at `angle` degrees measured
    /// clockwise from the top (12 o'clock). Used to place milestone markers and
    /// the running knob on a dial regardless of watch size.
    func ringOffset(radius: CGFloat, angle: Double) -> some View {
        let radians = angle * .pi / 180
        return offset(x: radius * sin(radians), y: -radius * cos(radians))
    }
}

/// Converts a value/total pair into an angle (degrees, clockwise from top).
func dialAngle(value: Double, total: Double) -> Double {
    guard total > 0 else { return 0 }
    return (value / total) * 360
}

/// The single milestone marker style shared by the setup and active dials:
/// a small accent-stroked, black-filled knob.
struct MilestoneMarker: View {
    var diameter: CGFloat = 9
    var body: some View {
        Circle()
            .fill(AppColor.background)
            .overlay(Circle().strokeBorder(AppColor.accent, lineWidth: 2))
            .frame(width: diameter, height: diameter)
    }
}
