//
//  SpeechApp.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 08/01/26.
//  Copyright © 2026 Girolamo Pinto. All rights reserved.
//

import SwiftUI

@main
struct Speech_Watch_AppApp: App {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerViewModel)
        }
    }
}
