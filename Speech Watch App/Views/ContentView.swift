//
//  ContentView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// Root screen: pick the speech duration with the Digital Crown.
struct ContentView: View {
    @EnvironmentObject var vm: TimerViewModel
    @State private var didRestore = false

    var body: some View {
        NavigationStack(path: $vm.navigationPath) {
            GeometryReader { geo in
                let dial = min(geo.size.width, geo.size.height) * 0.55
                VStack(spacing: geo.size.height * 0.04) {
                    Text("setMinute.title")
                        .font(.screenTitle)

                    dialPicker(diameter: dial)
                        .frame(height: dial)

                    Button {
                        if vm.selectedMinutes > 0 { vm.navigate(to: .setMilestones) }
                    } label: {
                        Text("action.next")
                    }
                    .buttonStyle(.pill)
                    .frame(width: dial * 1.05)
                    .disabled(vm.selectedMinutes <= 0)
                    .opacity(vm.selectedMinutes <= 0 ? 0.45 : 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 6)
            .background(AppColor.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.navigate(to: .selectPreset)
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    .accessibilityLabel(Text("menu.choose"))
                }
            }
            .navigationDestination(for: AppScreen.self, destination: destination)
        }
        .tint(AppColor.accent)
        .task {
            #if DEBUG
            if let screen = vm.uiTestScreen {
                vm.applyUITestSetup()
                switch screen {
                case "setStops": vm.navigate(to: .setMilestones)
                case "active":
                    vm.navigate(to: .setMilestones)
                    vm.navigate(to: .timerActive)
                case "presets": vm.navigate(to: .selectPreset)
                default: break
                }
                return
            }
            #endif
            // Restore a running timer that survived a relaunch mid-speech.
            if !didRestore, vm.consumeRestoredSession() {
                didRestore = true
                vm.navigate(to: .timerActive)
            }
        }
    }

    // MARK: - Subviews

    private func dialPicker(diameter: CGFloat) -> some View {
        ZStack {
            Group {
                Ellipse()
                    .strokeBorder(AppColor.faintStroke, lineWidth: 1)
                    .frame(width: diameter * 0.66, height: diameter * 0.8)
                    .offset(x: -diameter * 0.46)
                Ellipse()
                    .strokeBorder(AppColor.faintStroke, lineWidth: 1)
                    .frame(width: diameter * 0.66, height: diameter * 0.8)
                    .offset(x: diameter * 0.46)
            }
            .accessibilityHidden(true)

            Circle()
                .fill(AppColor.background)
                .overlay(Circle().strokeBorder(AppColor.accent, lineWidth: 2))
                .frame(width: diameter, height: diameter)

            Text(verbatim: "\(Int(vm.selectedMinutes))")
                .font(.dialNumber(diameter * 0.42))
                .minimumScaleFactor(0.5)
                .foregroundStyle(.white)
                .focusable()
                .digitalCrownRotation(
                    $vm.selectedMinutes,
                    from: 0, through: vm.maxMinutes, by: 1,
                    sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true
                )
                .accessibilityElement()
                .accessibilityLabel(Text("a11y.minutePicker"))
                .accessibilityValue(Text("a11y.minutes \(Int(vm.selectedMinutes))"))
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment: vm.selectedMinutes = min(vm.maxMinutes, vm.selectedMinutes + 1)
                    case .decrement: vm.selectedMinutes = max(0, vm.selectedMinutes - 1)
                    @unknown default: break
                    }
                }
        }
    }

    @ViewBuilder
    private func destination(_ screen: AppScreen) -> some View {
        switch screen {
        case .setMilestones: SetMilestonesView()
        case .timerActive: TimerActiveView()
        case .savePreset: SaveTimerView()
        case .editPresets: EditTimersView()
        case .selectPreset: SelectTimerView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TimerViewModel())
}
