//
//  PillButtonStyle.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// The single pill-button language used across the app: a capsule with a thin
/// coloured outline, optionally filled for the primary action.
struct PillButtonStyle: ButtonStyle {
    var tint: Color = AppColor.accent
    var prominent: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.pillLabel)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.vertical, 7)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(prominent ? tint.opacity(0.22) : .clear))
            .overlay(Capsule().strokeBorder(tint, lineWidth: 1.5))
            .foregroundStyle(prominent ? Color.white : tint)
            .opacity(configuration.isPressed ? 0.55 : 1)
            .contentShape(Capsule())
    }
}

extension ButtonStyle where Self == PillButtonStyle {
    static var pill: PillButtonStyle { PillButtonStyle() }
    static func pill(tint: Color, prominent: Bool = false) -> PillButtonStyle {
        PillButtonStyle(tint: tint, prominent: prominent)
    }
}
