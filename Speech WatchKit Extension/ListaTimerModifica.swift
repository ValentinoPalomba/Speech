//
//  ListaTimerModifica.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerModifica: View {
    var body: some View {
      VStack {
        Text("Timer List").font(.title).frame(width: 180.0, height: 5.0).padding(.top,10)
            .padding(.bottom,20)
                 List {
                     Button(action: {}){
                         Text("Timer 1                12:00 ")
                     }
                     Button(action: {}){
                         Text("Presentazione  12:00 ")
                     }
                     Button(action: {}){
                         Text("TedX                      12:00 ")
                     }
                     Button(action: {}){
                         Text("Timer 1                12:00 ")
                     }
                     Button(action: {}){
                         Text("Timer 1                12:00 ")
                     }
                 }
             }
             
    }
}

struct ListaTimerModifica_Previews: PreviewProvider {
    static var previews: some View {
        ListaTimerModifica()
    }
}
