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
                    .padding(.top,5)
                
                Text("\(Int(Time))")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .focusable(true)
                    .digitalCrownRotation($Time, from: 0.0, through: TimeSaved, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    
                    
                    .frame(width: 90, height: 90, alignment: .center)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4).frame(width: 100, height: 100, alignment: .center))
                    .padding(.top, 10)
                    .padding(.bottom,10)
                Button(action: {
                    if self.Time > 0.0
                    {
                    self.Tappable = true
                    }
                }){
                    Text("Next")
                }
                .opacity(opacityStart)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2)).opacity(opacityStart)
                .padding(.top, 42.0)
                .frame(width: 60, height: 5)
                .padding(.bottom, 20.0)
                NavigationLink(destination: MilestonesView(TimeDone: Time), isActive: $Tappable){
                    Text("")
                }.hidden()
                
                
                        
                            
                HStack {
                    NavigationLink(destination: ListaTimerModifica(), isActive: $ListaTimerModify){
                        Text("modify")
                    }.hidden()
                        .frame(width: 0, height: 0, alignment: .bottom)
                    NavigationLink(destination: ListaTimerSelezione().environmentObject(UserData()), isActive: $ListaTimerSelect){
                        Text("Select")
                    }.hidden()
                        .frame(width: 0, height: 0, alignment: .bottom)
                    
                }.frame(width: 0, height: 0, alignment: .bottom)
            }.padding(.top, 56.0).frame(width: 120, height: 200)
            
        }.contextMenu(menuItems: {
            
            Button(action: {}){
                Text("Create a New Timer")
            }.overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            Button(action: {
                self.ListaTimerModify = true
            }){
                Text("Modify an existing timer")
                
            }.overlay(Circle().stroke(Color.white, lineWidth: 2))
            Button(action: {
                self.ListaTimerSelect = true
            }){
                Text("Select an existing timer")
            }.overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ContentView()
            
            MilestonesView()
            
            ListaTimer()
                .environmentObject(UserData())
            
            ListaTimerSelezione()
                .environmentObject(UserData())
            
            TimerFinale()
                .environmentObject(UserData())
        }
    }
}
