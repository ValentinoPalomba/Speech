//
//  ContentView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine
struct ContentView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        NavigationStack(path: $timerViewModel.navigationPath) {
            VStack {
                VStack {
                    Text("Set time")
                        .font(.system(size: 20))
                        .frame(width: 150, alignment: .center)
                    
                    Text("\(Int(timerViewModel.selectedTime))")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .focusable(true)
                        .digitalCrownRotation($timerViewModel.selectedTime, from: 0.0, through: timerViewModel.maxMinutes, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .frame(width: 90, height: 90, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4).frame(width: 80, height: 80, alignment: .center))
                        .padding(.bottom)
                    
                    Button(action: {
                        if timerViewModel.selectedTime > 0.0 {
                            timerViewModel.navigate(to: .setMilestones)
                        }
                    }) {
                        Text("Next")
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .frame(width: 100)
                    .padding(.top, 13.0)
                }
                .padding(.top, 40.0)
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .setMilestones:
                    SetMilestonesView()
                case .customStops:
                    CustomStopsView()
                case .timerActive:
                    TimerActiveView()
                case .saveTimer(let timerValue):
                    SaveTimerView(name: "", timerString: "\(Int(timerValue))", timerDouble: timerValue)
                case .editTimers:
                    EditTimersView()
                case .selectTimer:
                    SelectTimerView()
                }
            }
            .contextMenu {
                Button(action: { timerViewModel.navigate(to: .saveTimer(timerValue: timerViewModel.selectedTime)) }) {
                    Label("Create a new timer", systemImage: "plus")
                }
                
                Button(action: { timerViewModel.navigate(to: .editTimers) }) {
                    Label("Modify existing", systemImage: "pencil")
                }
                
                Button(action: { timerViewModel.navigate(to: .selectTimer) }) {
                    Label("Select existing", systemImage: "list.bullet")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ContentView()
                .previewDevice("Apple Watch Series 5 - 44mm")
                .environmentObject(TimerViewModel())
            
            ContentView()
                .previewDevice("Apple Watch Series 5 - 40mm")
                .environmentObject(TimerViewModel())
            
            SetMilestonesView()
                .environmentObject(TimerViewModel())
            
            CustomStopsView()
                .environmentObject(TimerViewModel())
            
            SelectTimerView()
                .environmentObject(TimerViewModel())
            
            EditTimersView()
                .environmentObject(TimerViewModel())
            
            TimerActiveView()
                .environmentObject(TimerViewModel())
        }
    }
}
