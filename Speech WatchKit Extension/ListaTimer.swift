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
            Text("Customize the Stops")
                .padding(.top, 14.0)
            VStack{
                List(i..<NotificationArray.count) { item in
                    ForEach(self.userData.listElements, id: \.id){ element in
                        ListaTimerRow(element: element)
                    }
                }
            }.edgesIgnoringSafeArea(.all)
            
            
            

            HStack {
                NavigationLink(destination: TimerFinale(timeTimer: Int(TimerLista)).environmentObject(userData)){
                        Text("Skip")
                        }
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))


                NavigationLink(destination: TimerFinale(timeTimer: Int(TimerLista)).environmentObject(userData)){
                    Text("Next")
                }
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))

            }.frame(width: 180, height: nil, alignment: .center)
        }.frame(width: nil, height: 190, alignment: .bottom)
    }
}

struct ListaTimer_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ListaTimer()
                .previewDevice("Apple Watch Series 4 - 40mm")
            ListaTimer()
                .previewDevice("Apple Watch Series 4 - 40mm")
        }
        .environmentObject(UserData())
    }
}
