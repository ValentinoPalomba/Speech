//
//  TimerActiveView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine

struct TimerActiveView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State var isShowingAlert = false
    
    var body: some View {
        VStack {
            Text("\(Int(timerViewModel.currentTime))")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .focusable(true)
                .frame(width: 110, height: 110, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(timerViewModel.isTimerRunning ? Color.green : Color.white, lineWidth: 4)
                )
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                if !timerViewModel.isTimerRunning {
                    Button(action: {
                        timerViewModel.startTimer()
                    }) {
                        Text("Start")
                    }
                    .tint(.green)
                } else {
                    Button(action: {
                        timerViewModel.stopTimer()
                    }) {
                        Text("Stop")
                    }
                    .tint(.red)
                }
                
                Button(action: {
                    timerViewModel.saveNewTimer(name: "Timer", time: timerViewModel.selectedTime)
                }) {
                    Text("Save")
                }
                .tint(.blue)
            }
            .padding(.top, 10)
        }
        .navigationTitle("Timer")
        .contextMenu {
            Button(action: { timerViewModel.popToRoot() }) {
                Label("New timer", systemImage: "plus")
            }
            
            Button(action: { timerViewModel.navigate(to: .editTimers) }) {
                Label("Modify timers", systemImage: "pencil")
            }
            
            Button(action: { timerViewModel.navigate(to: .selectTimer) }) {
                Label("Select timer", systemImage: "list.bullet")
            }
        }
    }
}

struct TimerActiveView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TimerActiveView()
                .previewDevice("Apple Watch Series 6 - 44mm")
                .environmentObject(TimerViewModel())
            
            TimerActiveView()
                .previewDevice("Apple Watch Series 6 - 40mm")
                .environmentObject(TimerViewModel())
        }
    }
}