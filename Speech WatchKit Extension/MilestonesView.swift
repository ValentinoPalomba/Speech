//
//  MilestonesView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications
import Combine

struct MilestonesView: View {
    @State var Time = 0.0
    @State var TimeDone = 0.0
    @State var MilestoneTime : [Double] = []
    @State private var opacityStop = 0.0
    @State private var opacityStart = 1.0
    @State private var opacitySet = 1.0
    @State private var blueCircleX = 45.0
    @State private var blueCircleY = 55.0
    var body: some View {
        VStack{
            VStack{
                Text("Set the Milestones")
                    .padding(.top,18)
                    .padding(.bottom,9)
                VStack{
                    Text("\(Int(Time))")
                        .focusable(true)
                        .digitalCrownRotation($Time, from: 0.0, through: TimeDone, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                        .onAppear(){
                            
                        }
                        .frame(width: 90, height: 90, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 3).frame(width: 100, height: 90, alignment: .center).position(x: 45, y: 45).overlay(Circle().trim(from: 0.0, to : CGFloat(Time / TimeDone)).stroke(Color.blue, style: StrokeStyle(lineWidth : 3, lineCap: .round, lineJoin: .round)).position(x: 45, y: 45).frame(width: 90, height: 90, alignment: .center)))
                }
            }
            
            ZStack{
                HStack{
                    Button(action : {
                        self.MilestoneTime.append(self.Time)
                        let content = UNMutableNotificationContent()
                        content.title = "Sono passati \(self.Time)"
                        content.body = "Sono passati \(self.Time)"
                        content.sound = UNNotificationSound.defaultCritical
                        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
                        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
                            if let error = error {
                                print("Error: ", error)
                            }
                        }
                        let notificationContent = UNMutableNotificationContent()
                        
                        // Add the content to the notification content
                        notificationContent.title = "Sono passati \(ceil((self.Time*100)/100)) minuti"
                        notificationContent.body = "Test body"
                        notificationContent.badge = NSNumber(value: 1)
                       
                        notificationContent.sound = UNNotificationSound.default
                        
                        // Add an attachment to the notification content
                        if let url = Bundle.main.url(forResource: "dune", withExtension: "png") {
                            if let attachment = try? UNNotificationAttachment(identifier: "dune", url: url, options: nil) {
                                notificationContent.attachments = [attachment]
                            }
                        }
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.Time*60,repeats: false)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
                        
                        NotificationArray.append(request)
                        print("Added at time \(self.Time)")
                        TimeSetted = true
                        //self.setX = self.Time
                        //self.setY = self.TimeDone
                    }){
                        Text("Set")
                    }.opacity(opacitySet)
                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.blue)).opacity(opacitySet).frame(width: 70, height: 40, alignment: .center)
                    
                    NavigationLink(destination: ListaTimer(TimerLista: TimeDone).environmentObject(UserData())){
                        Text("Next")
                    }.opacity(opacityStart)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2)).opacity(opacityStart).frame(width: 70, height: 40, alignment: .center)
                    
                    
                }
            }
        }
    }
}

struct MilestonesView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            MilestonesView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            MilestonesView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
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
