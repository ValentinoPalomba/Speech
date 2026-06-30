//
//  SaveTimerView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// Create or edit a preset: name, colour and the configured duration.
struct SaveTimerView: View {
    @EnvironmentObject var vm: TimerViewModel

    @State private var name = ""
    @State private var colorIndex = 0
    @State private var seeded = false

    private var isEditing: Bool { vm.editingPreset != nil }
    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text(TimeFormat.clock(seconds: vm.selectedSeconds))
                    .font(.dialNumber(36))
                    .monospacedDigit()
                    .foregroundStyle(.white)

                TextField("savePreset.namePlaceholder", text: $name)
                    .font(.system(.body, design: .rounded))
                    .multilineTextAlignment(.center)

                HStack(spacing: 7) {
                    ForEach(0..<TimerPalette.count, id: \.self) { index in
                        Circle()
                            .fill(TimerPalette.color(index))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle().strokeBorder(.white, lineWidth: colorIndex == index ? 2.5 : 0)
                            )
                            .onTapGesture { colorIndex = index }
                            .accessibilityLabel(Text("a11y.color \(index + 1)"))
                            .accessibilityAddTraits(colorIndex == index ? [.isSelected] : [])
                    }
                }
                .padding(.vertical, 2)

                Button {
                    vm.savePreset(name: name, colorIndex: colorIndex)
                } label: {
                    Text("action.save")
                }
                .buttonStyle(.pill(tint: TimerPalette.color(colorIndex), prominent: true))
                .disabled(trimmedName.isEmpty || vm.selectedSeconds <= 0)
                .opacity(trimmedName.isEmpty ? 0.45 : 1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(AppColor.background)
        .navigationTitle(isEditing ? "savePreset.title.edit" : "savePreset.title.new")
        .onAppear {
            guard !seeded else { return }
            name = vm.draftName
            colorIndex = vm.draftColorIndex
            seeded = true
        }
    }
}

#Preview {
    SaveTimerView()
        .environmentObject({
            let vm = TimerViewModel()
            vm.selectedMinutes = 12
            return vm
        }())
}
