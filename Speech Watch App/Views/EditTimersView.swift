//
//  EditTimersView.swift
//  Speech Watch App
//
//  Created by Valentino Palomba on 30/06/26.
//

import SwiftUI

/// Manage saved presets: tap to edit, swipe to delete.
struct EditTimersView: View {
    @EnvironmentObject var vm: TimerViewModel

    var body: some View {
        Group {
            if vm.savedTimers.isEmpty {
                EmptyPresetsView()
            } else {
                List {
                    ForEach(vm.savedTimers) { timer in
                        Button {
                            vm.beginEditing(timer)
                        } label: {
                            SavedTimerRow(timer: timer)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vm.deletePreset(timer)
                            } label: {
                                Label("action.delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete { vm.deletePresets(at: $0) }
                }
                .listStyle(.carousel)
            }
        }
        .background(AppColor.background)
        .navigationTitle("presets.manage.title")
    }
}

#Preview {
    EditTimersView()
        .environmentObject(TimerViewModel())
}
