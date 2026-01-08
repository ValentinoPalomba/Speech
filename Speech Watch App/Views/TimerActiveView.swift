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

struct SpotlightShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Broad source at the top, natural spread at the bottom
        path.move(to: CGPoint(x: width * 0.1, y: 0))
        path.addLine(to: CGPoint(x: width * 0.85, y: 0))
        path.addLine(to: CGPoint(x: width * 1.15, y: height * 1.2))
        path.addLine(to: CGPoint(x: -width * 0.15, y: height * 1.2))
        path.closeSubpath()
        
        return path
    }
}

struct TimerActiveView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State var isShowingAlert = false
    
    var body: some View {
        ZStack {
            // REFINED VOLUMETRIC SPOTLIGHT (Middle ground width)
            ZStack {
                // The main beam
                SpotlightShape()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.clear, location: 0),
                                .init(color: Color.blue.opacity(0.1), location: 0.6),
                                .init(color: Color.blue.opacity(0.1), location: 0.8),
                                .init(color: Color.clear, location: 0.99)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 150, height: 240)
                    .blur(radius: 8)
                
                // The glowing floor ellipse
                Ellipse()
                    .fill(Color.blue.opacity(0.25))
                    .frame(width: 180, height: 90)
                    .offset(y: 115)
                    .blur(radius: 5)
            }
            .offset(y: -40)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 25)
                
                ZStack {
                    // Background Circle
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .frame(width: 120, height: 120)
                    
                    // Progress Arc
                    Circle()
                        .trim(from: 0.0, to: CGFloat(timerViewModel.selectedTime > 0 ? timerViewModel.currentTime / timerViewModel.selectedTime : 0))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: timerViewModel.currentTime)
                    
                    // Milestone Dots (White dots)
                    ForEach(timerViewModel.milestones, id: \.self) { milestone in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                            .offset(y: -65) // Adjusted for 130 circle
                            .rotationEffect(.degrees((milestone / timerViewModel.selectedTime) * 360))
                    }
                    
                    // Current Position Knob (Black background, blue stroke)
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .background(Circle().fill(Color.black))
                        .frame(width: 14, height: 14)
                        .offset(y: -65) // Adjusted for 130 circle
                        .rotationEffect(.degrees((timerViewModel.currentTime / timerViewModel.selectedTime) * 360))
                        .animation(.linear, value: timerViewModel.currentTime)
                    
                    Text(timerViewModel.formatTime(timerViewModel.currentTime))
                        .font(.system(size: 32, weight: .light, design: .rounded))
                }
                .frame(height: 140)
                
                Spacer()
                
                Button(action: {
                    if timerViewModel.isTimerRunning {
                        timerViewModel.stopTimer()
                    } else {
                        timerViewModel.startTimer()
                    }
                }) {
                    Text(timerViewModel.isTimerRunning ? "Stop" : "Start")
                        .font(.system(size: 18))
                        .frame(width: 100, height: 40)
                        .overlay(
                            Capsule()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.bottom, 25)
            }
        }
        .navigationTitle("")
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
