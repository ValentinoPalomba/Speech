//
//  TimerActiveView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// A cone of light: narrow at the dial, flaring outward toward the bottom —
/// the "speaker under a spotlight" metaphor at the heart of the design.
struct SpotlightShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: w * 0.40, y: 0))
        path.addLine(to: CGPoint(x: w * 0.60, y: 0))
        path.addLine(to: CGPoint(x: w * 1.02, y: h))
        path.addLine(to: CGPoint(x: -w * 0.02, y: h))
        path.closeSubpath()
        return path
    }
}

/// Active countdown screen.
struct TimerActiveView: View {
    @EnvironmentObject var vm: TimerViewModel

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let dial = side * 0.66
            let cx = geo.size.width / 2
            let dialCenterY = geo.size.height * 0.40
            let coneHeight = geo.size.height * 0.72

            ZStack {
                AppColor.background.ignoresSafeArea()

                spotlight
                    .frame(width: dial * 1.8, height: coneHeight)
                    .blur(radius: 10)
                    .position(x: cx, y: dialCenterY + coneHeight / 2)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)

                dialView(diameter: dial)
                    .frame(width: dial, height: dial)
                    .position(x: cx, y: dialCenterY)

                actionButton
                    .frame(width: dial)
                    .position(x: cx, y: geo.size.height * 0.88)
            }
        }
        .background(AppColor.background)
        .navigationTitle(Text(verbatim: ""))
        .navigationBarBackButtonHidden(vm.runState == .running)
        .onAppear { vm.prepareActiveIfNeeded() }
    }

    private var spotlight: some View {
        SpotlightShape()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: AppColor.highlight.opacity(0.40), location: 0),
                        .init(color: AppColor.accent.opacity(0.14), location: 0.45),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    private func dialView(diameter: CGFloat) -> some View {
        let radius = diameter / 2
        let total = vm.sessionMinutes
        return ZStack {
            Circle()
                .strokeBorder(AppColor.faintStroke, lineWidth: 1)

            Circle()
                .trim(from: 0, to: CGFloat(vm.progress))
                .stroke(AppColor.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.2), value: vm.progress)

            ForEach(vm.milestones.filter { $0.minutes > 0 && $0.minutes < total }) { milestone in
                MilestoneMarker(diameter: diameter * 0.075)
                    .ringOffset(radius: radius, angle: dialAngle(value: milestone.minutes, total: total))
            }
            .accessibilityHidden(true)

            Circle()
                .fill(AppColor.background)
                .overlay(Circle().strokeBorder(AppColor.accent, lineWidth: 2))
                .frame(width: diameter * 0.11, height: diameter * 0.11)
                .ringOffset(radius: radius, angle: vm.progress * 360)
                .animation(.linear(duration: 0.2), value: vm.progress)
                .accessibilityHidden(true)

            Text(vm.remainingClock)
                .font(.dialNumber(diameter * 0.26))
                .monospacedDigit()
                .minimumScaleFactor(0.5)
                .foregroundStyle(.white)
        }
        .accessibilityElement()
        .accessibilityLabel(Text("a11y.timeRemaining"))
        .accessibilityValue(Text(vm.remainingClock))
    }

    @ViewBuilder
    private var actionButton: some View {
        switch vm.runState {
        case .idle:
            Button { vm.start() } label: { Text("action.start") }
                .buttonStyle(.pill(tint: AppColor.accent, prominent: true))
        case .running:
            Button { vm.stop() } label: { Text("action.stop") }
                .buttonStyle(.pill(tint: AppColor.destructive))
        case .finished:
            Button { vm.finishAndReset() } label: { Text("action.done") }
                .buttonStyle(.pill(tint: AppColor.accent, prominent: true))
        }
    }
}

#Preview {
    TimerActiveView()
        .environmentObject({
            let vm = TimerViewModel()
            vm.selectedMinutes = 7
            vm.prepareActiveIfNeeded()
            return vm
        }())
}
