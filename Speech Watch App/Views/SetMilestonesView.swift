//
//  SetMilestonesView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// Second step: place "stops" (milestones) along the speech with the crown.
struct SetMilestonesView: View {
    @EnvironmentObject var vm: TimerViewModel
    @State private var selection: Double = 0

    private var total: Double { vm.selectedMinutes }
    private var isOnMilestone: Bool { vm.hasMilestone(atMinutes: selection) }

    var body: some View {
        GeometryReader { geo in
            let dial = min(geo.size.width, geo.size.height) * 0.58
            VStack(spacing: geo.size.height * 0.05) {
                Text("setStops.title")
                    .font(.screenTitle)

                milestoneDial(diameter: dial)
                    .frame(width: dial, height: dial)

                HStack(spacing: 8) {
                    Button {
                        vm.toggleMilestone(atMinutes: selection)
                    } label: {
                        Text(isOnMilestone ? "action.remove" : "action.add")
                    }
                    .buttonStyle(.pill(tint: isOnMilestone ? AppColor.destructive : AppColor.accent))
                    .disabled(selection <= 0 || selection >= total)

                    Button {
                        vm.navigate(to: .timerActive)
                    } label: {
                        Text("action.done")
                    }
                    .buttonStyle(.pill(tint: AppColor.accent, prominent: true))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 6)
        .background(AppColor.background)
        .navigationTitle(Text(verbatim: ""))
        .onAppear {
            #if DEBUG
            if vm.uiTestScreen == "setStops" { selection = 10 }
            #endif
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.beginNewPreset()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .accessibilityLabel(Text("menu.savePreset"))
            }
        }
    }

    private func milestoneDial(diameter: CGFloat) -> some View {
        let radius = diameter / 2
        return ZStack {
            Circle()
                .strokeBorder(AppColor.faintStroke, lineWidth: 1)

            Circle()
                .trim(from: 0, to: CGFloat(total > 0 ? selection / total : 0))
                .stroke(AppColor.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Start knob at the top.
            Circle()
                .fill(AppColor.accent)
                .frame(width: diameter * 0.09, height: diameter * 0.09)
                .ringOffset(radius: radius, angle: 0)
                .accessibilityHidden(true)

            // Existing milestones (only those that fit the current duration).
            ForEach(vm.milestones.filter { $0.minutes > 0 && $0.minutes < total }) { milestone in
                MilestoneMarker(diameter: diameter * 0.09)
                    .ringOffset(radius: radius, angle: dialAngle(value: milestone.minutes, total: total))
            }
            .accessibilityHidden(true)

            // Current selection knob.
            Circle()
                .fill(AppColor.accent.opacity(0.25))
                .overlay(Circle().strokeBorder(AppColor.accent, lineWidth: 2))
                .frame(width: diameter * 0.12, height: diameter * 0.12)
                .ringOffset(radius: radius, angle: dialAngle(value: selection, total: total))
                .accessibilityHidden(true)

            Text(TimeFormat.clock(minutes: selection))
                .font(.dialNumber(diameter * 0.24))
                .minimumScaleFactor(0.5)
                .foregroundStyle(.white)
        }
        .focusable()
        .digitalCrownRotation(
            $selection,
            from: 0, through: max(total, 0.0001), by: 1,
            sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true
        )
        .accessibilityElement()
        .accessibilityLabel(Text("a11y.stopPosition"))
        .accessibilityValue(Text(TimeFormat.clock(minutes: selection)))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: selection = min(total, selection + 1)
            case .decrement: selection = max(0, selection - 1)
            @unknown default: break
            }
        }
    }
}

#Preview {
    SetMilestonesView()
        .environmentObject({
            let vm = TimerViewModel()
            vm.selectedMinutes = 10
            return vm
        }())
}
