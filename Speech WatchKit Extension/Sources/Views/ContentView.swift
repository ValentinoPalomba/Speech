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
    @State var Time = 0.0
    @State var MilestoneTime = [Double]()
    @State var ListaTimerModify = false
    @State var ListaTimerSelect = false
    @State var Tappable = false
    @State private var opacityStart = 1.0
    @State private var opacityStop = 0.0
    @State private var opacitySet = 0.0
    var body: some View {
        VStack {
            
            VStack {
                Text("Set time")
                    .font(.system(size: 20))
                    .frame(width: 150, alignment: .center)
                
                Text("\(Int(Time))")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .focusable(true)
                    .digitalCrownRotation($Time, from: 0.0, through: TimeSaved, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    .frame(width: 90, height: 90, alignment: .center)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4).frame(width: 80, height: 80, alignment: .center))
                    .padding(.bottom)
                
                NavigationLink(destination: MilestonesView(TimeDone: Time), isActive: $Tappable){
                    Text("Next")
                }
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
                .opacity(opacityStart)
                .frame(width: 60, height: 5)
                .padding(.top, 13.0)
                .padding(.bottom, 20.0)
                Button(action: {
                    if self.Time > 0.0
                    {
                    self.Tappable = true
                    }
                }){
                    Text("")
                }
                .hidden()
                .frame(height: 15, alignment: .center)
            }
            .padding(.top, 56.0)
            .frame(width: 120, height: 200)
            
        }
        .contextMenu(menuItems: {
            
            NavigationLink(destination: SaveTimerView(name: "", timerString: "\(Int(Time))", timerDouble: Time)){
                Text("Create a new timer")
            }
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            NavigationLink(
                destination: ListaTimerModificaView().environmentObject(UserData()), isActive: $ListaTimerModify){
                Text("Modify an existing timer")
            }
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            NavigationLink(destination: ListaTimerSelezioneView().environmentObject(UserData()), isActive: $ListaTimerSelect){
                Text("Select an existing timer")
            }
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ContentView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            ContentView()
                .previewDevice("Apple Watch Series 5 - 40mm")
            
            MilestonesView()
            
            ListaTimerView()
                .environmentObject(UserData())
            
            ListaTimerSelezioneView()
                .environmentObject(UserData())
            
            ListaTimerModificaView()
                .environmentObject(UserData())
            
            TimerFinaleView()
                .environmentObject(UserData())
        }
    }
}
