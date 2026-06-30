//
//  SpeechApp.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

@main
struct Speech_Watch_AppApp: App {
    @StateObject private var timerViewModel = TimerViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerViewModel)
                .tint(AppColor.accent)
                .task {
                    #if DEBUG
                    if ProcessInfo.processInfo.environment["SPEECH_UITEST"] == "1" { return }
                    #endif
                    await timerViewModel.requestNotificationAuthorizationIfNeeded()
                }
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                    case .active:
                        timerViewModel.onScenePhaseActive()
                    case .inactive, .background:
                        timerViewModel.onScenePhaseInactive()
                    @unknown default:
                        break
                    }
                }
        }
    }
}
