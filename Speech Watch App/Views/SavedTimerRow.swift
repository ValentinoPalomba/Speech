//
//  SavedTimerRow.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// A saved preset rendered as a capsule with a per-timer coloured outline.
struct SavedTimerRow: View {
    let timer: SavedTimer

    private var tint: Color { TimerPalette.color(timer.colorIndex) }

    var body: some View {
        HStack(spacing: 8) {
            Text(timer.name)
                .font(.system(.body, design: .rounded))
                .lineLimit(1)
                .foregroundStyle(.white)
            Spacer(minLength: 6)
            Text(timer.displayTime)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(tint)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Capsule().fill(Color.white.opacity(0.04)))
        .overlay(Capsule().strokeBorder(tint, lineWidth: 1.5))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(verbatim: "\(timer.name), \(timer.displayTime)"))
    }
}

#Preview {
    VStack(spacing: 10) {
        SavedTimerRow(timer: SavedTimer(name: "Keynote", durationSeconds: 600, colorIndex: 0))
        SavedTimerRow(timer: SavedTimer(name: "Pitch", durationSeconds: 720, colorIndex: 1))
        SavedTimerRow(timer: SavedTimer(name: "Lightning", durationSeconds: 300, colorIndex: 2))
    }
    .padding()
    .background(Color.black)
}
