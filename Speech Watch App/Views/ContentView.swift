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
            VStack(spacing: 15) {
                HStack(spacing: 0) {
                    Text("Set ")
                        .font(.system(size: 20))
                    Text("minute")
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.top, 5)

                ZStack {
                    // Decorative side circles
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        .frame(width: 65, height: 65)
                        .offset(x: -35)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        .frame(width: 65, height: 65)
                        .offset(x: 35)
                    
                    // Main Timer Circle
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .background(Circle().fill(Color.black))
                        .frame(width: 90, height: 90)

                    
                    Text("\(Int(timerViewModel.selectedTime))")
                        .font(.system(size: 44, weight: .light, design: .rounded))
                        .focusable(true)
                        .digitalCrownRotation($timerViewModel.selectedTime, from: 0.0, through: timerViewModel.maxMinutes, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                }
                .frame(height: 100)

                Button(action: {
                    if timerViewModel.selectedTime > 0.0 {
                        timerViewModel.navigate(to: .setMilestones)
                    }
                }) {
                    Text("next")
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)
                .frame(width: 80, height: 32)
                .overlay(
                    Capsule()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .setMilestones:
                    SetMilestonesView()
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
            
            SelectTimerView()
                .environmentObject(TimerViewModel())
            
            EditTimersView()
                .environmentObject(TimerViewModel())
            
            TimerActiveView()
                .environmentObject(TimerViewModel())
        }
    }
}
