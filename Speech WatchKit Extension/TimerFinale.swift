//
//  TimerFinale.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine

struct TimerFinale: View {
    @State var timeTimer = 0
    @State private var opacityStart = 1.0
    @State private var opacityStop = 0.0
    @State private var opacitySave = 0.0
    @State var ListaTimerModify = false
    @State var ListaTimerSelect = false
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            Text("\(timeTimer)").font(.largeTitle)
                .focusable(true)
                .frame(width: 110, height: 110, alignment: .center)
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .padding(.top, 28.0)
            
            ZStack {
                HStack {
                    Button(action : {
                        withAnimation{
                            self.opacityStart -= 1.0
                            self.opacityStop += 1.0
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: 60, repeats: true){_ in
                            if self.timeTimer==1{
                                self.opacityStart += 1.0
                                self.opacityStop -= 1.0
                            }
                            if self.timeTimer>0{
                                self.timeTimer -= 1
                                print("Minuti")
                            }
                        }
                        for notification in NotificationArray{
                            UNUserNotificationCenter.current().add(notification, withCompletionHandler: {(error) in if let error = error {
                                print(error)
                            }})
                        }
                    }){
                        Text("Start")
                    }.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
                    .fixedSize()
                    .opacity(opacityStart)
                }
                HStack{
                    Button(action : {
                        withAnimation{
                            self.opacityStart += 1.0
                            self.opacityStop -= 1.0
                        }
                        TimeSetted = false
                    }){
                        Text("Stop")
                    }.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
                    .fixedSize()
                    .opacity(opacityStop)
                }
                HStack{
                    Button(action: {
                        self.userData.listElementsSaved.append(ListElementSaved(name: "Timer", timer: String(self.timeTimer)))
                        print("SVAE")
                        print(String(self.timeTimer))
                    }){
                        Text("Save")
                    }.environmentObject(userData)
                }.opacity(opacitySave)
                
                HStack {
                    NavigationLink(destination: ListaTimerModifica(), isActive: $ListaTimerModify){
                        Text("modify")
                    }.hidden()
                    .frame(width: 0, height: 0, alignment: .bottom)
                    NavigationLink(destination: ListaTimerSelezione().environmentObject(userData), isActive: $ListaTimerSelect){
                        Text("Select")
                    }.hidden()
                    .frame(width: 0, height: 0, alignment: .bottom)
                    
                }.frame(width: 0, height: 0, alignment: .bottom)
            }
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

struct TimerFinale_Previews: PreviewProvider {
    static var previews: some View {
        TimerFinale()
            .environmentObject(UserData())
    }
}
