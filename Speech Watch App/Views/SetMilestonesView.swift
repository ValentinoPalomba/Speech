//
//  SetMilestonesView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine

struct SetMilestonesView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State var milestoneSelection = 0.0
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text("Set ")
                    .font(.system(size: 16))
                Text("stops")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.top, 5)
            
            ZStack {
                // Background Circle
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 90, height: 90)
                
                // Progress Arc
                Circle()
                    .trim(from: 0.0, to: CGFloat(timerViewModel.selectedTime > 0 ? milestoneSelection / timerViewModel.selectedTime : 0))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                
                // Static Start Knob
                Circle()
                    .fill(Color.blue)
                    .frame(width: 14, height: 14)
                    .offset(y: -45)
                
                // Milestone Dots (existing ones)
                ForEach(timerViewModel.milestones, id: \.self) { milestone in
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .background(Circle().fill(Color.black))
                        .frame(width: 10, height: 10)
                        .offset(y: -45)
                        .rotationEffect(.degrees((milestone / timerViewModel.selectedTime) * 360))
                }
                
                // Current Selection Knob
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .background(Circle().fill(Color.blue.opacity(0.2)))
                    .frame(width: 14, height: 14)
                    .offset(y: -45)
                    .rotationEffect(.degrees((milestoneSelection / timerViewModel.selectedTime) * 360))
                
                // Time Text (MM:SS format)
                Text(timerViewModel.formatTime(milestoneSelection))
                    .font(.system(size: 22, weight: .light, design: .rounded))
            }
            .focusable(true)
            .digitalCrownRotation($milestoneSelection, from: 0.0, through: timerViewModel.selectedTime, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            .frame(width: 100, height: 100)
            
            HStack(spacing: 8) {
                Button(action : {
                    if timerViewModel.hasMilestone(at: milestoneSelection) {
                        timerViewModel.removeMilestone(at: milestoneSelection)
                    } else {
                        timerViewModel.addMilestone(at: milestoneSelection)
                    }
                }){
                    Text(timerViewModel.hasMilestone(at: milestoneSelection) ? "Remove" : "Add")
                        .font(.system(size: 13))
                        .frame(width: 70, height: 28)
                        .overlay(
                            Capsule()
                                .stroke(timerViewModel.hasMilestone(at: milestoneSelection) ? Color.red : Color.blue, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    timerViewModel.navigate(to: .timerActive)
                }) {
                    Text("Done")
                        .font(.system(size: 13))
                        .frame(width: 70, height: 28)
                        .overlay(
                            Capsule()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct SetMilestonesView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            SetMilestonesView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            SetMilestonesView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
        .environmentObject(TimerViewModel())
    }
}