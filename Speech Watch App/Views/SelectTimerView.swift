//
//  SelectTimerView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// Choose a saved preset to load into the setup flow.
struct SelectTimerView: View {
    @EnvironmentObject var vm: TimerViewModel

    var body: some View {
        Group {
            if vm.savedTimers.isEmpty {
                EmptyPresetsView()
            } else {
                List {
                    ForEach(vm.savedTimers) { timer in
                        Button {
                            vm.selectPreset(timer)
                        } label: {
                            SavedTimerRow(timer: timer)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.carousel)
            }
        }
        .background(AppColor.background)
        .navigationTitle("presets.choose.title")
        .toolbar {
            if !vm.savedTimers.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.navigate(to: .editPresets)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .accessibilityLabel(Text("menu.edit"))
                }
            }
        }
    }
}

/// Shown when there are no presets yet.
struct EmptyPresetsView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "timer")
                .font(.largeTitle)
                .foregroundStyle(AppColor.accent)
            Text("presets.empty.title")
                .font(.system(.headline, design: .rounded))
                .multilineTextAlignment(.center)
            Text("presets.empty.subtitle")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}

#Preview {
    SelectTimerView()
        .environmentObject({
            let vm = TimerViewModel()
            return vm
        }())
}
