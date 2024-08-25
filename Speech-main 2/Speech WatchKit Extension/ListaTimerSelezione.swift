//
//  ListaTimerSelezione.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import Combine

struct ListaTimerSelezione: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            if #available(watchOSApplicationExtension 7.0, *) {
                Text("Choose timer").font(.title2).frame(width: 180.0, height: 10.0).padding(.top,10).padding(.bottom,20)
            } else {
                // Fallback on earlier versions
                Text("Choose timer").font(.system(size: 30.0)).frame(width: 180.0, height: 10.0).padding(.top)
            }
            List(self.userData.listElementsSaved, id: \.id){ element in
                NavigationLink(
                    destination: MilestonesView(TimeDone: element.timerDouble)){
                    ListaTimerSavedRow(element: element)
                }
            }
        }
        
    }
}

struct ListaTimerSelezione_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ListaTimerSelezione()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            ListaTimerSelezione()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
        .environmentObject(UserData())
    }
}
