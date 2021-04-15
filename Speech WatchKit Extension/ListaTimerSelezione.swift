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
            Text("Timer List").font(.largeTitle).frame(width: 180.0, height: 10.0).padding(.top)
                List(self.userData.listElementsSaved, id: \.id){ element in
                    ListaTimerSavedRow(element: element)
                }
        }
        
    }
}

struct ListaTimerSelezione_Previews: PreviewProvider {
    static var previews: some View {
        ListaTimerSelezione()
            .environmentObject(UserData())
    }
}
