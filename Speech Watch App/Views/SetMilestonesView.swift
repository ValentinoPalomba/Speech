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
        VStack{
            VStack{
                Text("Set the Milestones")
                    .padding(.top, 10)
                
                VStack{
                    Text("\(Int(milestoneSelection))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .focusable(true)
                        .digitalCrownRotation($milestoneSelection, from: 0.0, through: timerViewModel.selectedTime, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .frame(width: 90, height: 90, alignment: .center)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 4)
                                .frame(width: 80, height: 80)
                        )
                        .overlay(
                            Circle()
                                .trim(from: 0.0, to: CGFloat(timerViewModel.selectedTime > 0 ? milestoneSelection / timerViewModel.selectedTime : 0))
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))
                        )
                }
            }
            
            HStack(spacing: 10) {
                Button(action : {
                    timerViewModel.addMilestone(at: milestoneSelection)
                }){
                    Text("Set")
                }
                .tint(.blue)
                
                Button(action: {
                    timerViewModel.navigate(to: .customStops)
                }) {
                    Text("Next")
                }
                .tint(.gray)
            }
            .padding(.top, 10)
        }
        .navigationTitle("Milestones")
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

struct Arc : Shape{
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: 0, y: 0), radius: rect.width, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}