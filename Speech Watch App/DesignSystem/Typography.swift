//
//  Typography.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

extension Font {
    /// Large, light, rounded numerals used inside the dials.
    static func dialNumber(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light, design: .rounded)
    }

    /// Screen titles ("Set minute", "Set stops", ...). Honours Dynamic Type.
    static var screenTitle: Font {
        .system(.headline, design: .rounded)
    }

    /// Compact rounded label for pill buttons and rows.
    static var pillLabel: Font {
        .system(.footnote, design: .rounded).weight(.medium)
    }
}
