//
//  ListaTimer.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import Combine

struct ListaTimer: View {
    @State var i = 0
    @State private var name = [Int]()
    @State var TimerLista = 0.0
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            VStack{
                ScrollView {
                    ForEach(i..<NotificationArray.count) { item in
                        
                        ListaTimerRow(element: self.userData.listElements.first!, notification: NotificationArray[item])
                    }
                }
            }
            
            HStack {
                NavigationLink(destination: TimerFinale(timeTimer: Int(TimerLista)).environmentObject(userData)){
                    Text("Next")
                }
                .background(RoundedRectangle(cornerRadius: 22).stroke(Color.white, lineWidth: 2))

            }.frame(width: 180, height: nil, alignment: .center)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle(Text("Customize the stops"))
        
        
    }
}

struct ListaTimer_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ListaTimer()
                .previewDevice("Apple Watch Series 6 - 44mm")
            ListaTimer()
                .previewDevice("Apple Watch Series 6 - 40mm")
        }
        .environmentObject(UserData())
    }
}
