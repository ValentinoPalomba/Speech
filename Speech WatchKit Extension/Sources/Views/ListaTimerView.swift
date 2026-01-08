//
//  ListaTimerView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerView: View {
    @State var TimerLista = 0.0
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            Text("Customize the stops")
                .padding(.top, 20.0)
                .padding(.bottom)
            VStack{
                List {
                    ForEach(0..<NotificationArray.count, id: \.self) { _ in
                        ForEach(self.userData.listElements, id: \.id){ element in
                            ListaTimerRowView(element: element)
                        }
                    }
                }
            }
            
            HStack {
                NavigationLink(destination: TimerFinaleView(timeTimer: Int(TimerLista)).environmentObject(userData)){
                        Text("Skip")
                        }
                .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2))
                .frame(width: 70.0, height: nil, alignment: .center)


                NavigationLink(destination: TimerFinaleView(timeTimer: Int(TimerLista)).environmentObject(userData)){
                    Text("Next")
                }
                .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2))
                .frame(width: 70.0, height: nil, alignment: .center)

            }.frame(width: 180, height: nil, alignment: .center)
        }.frame(width: nil, height: 190, alignment: .bottom)
    }
}

struct ListaTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            ListaTimerView()
                .previewDevice("Apple Watch Series 6 - 44mm")
            ListaTimerView()
                .previewDevice("Apple Watch Series 6 - 40mm")
        }
        .environmentObject(UserData())
    }
}
