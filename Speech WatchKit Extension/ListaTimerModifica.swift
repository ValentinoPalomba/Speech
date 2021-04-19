//
//  ListaTimerModifica.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerModifica: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            if #available(watchOSApplicationExtension 7.0, *) {
                Text("Edit timer").font(.title2).frame(width: 180.0, height: 5.0).padding(.top,10)
                    .padding(.bottom,20)
            } else {
                // Fallback on earlier versions
                Text("Edit timer").font(.system(size: 30.0)).frame(width: 180.0, height: 10.0).padding(.top)
            }
            List(userData.listElementsSaved){ element in
                ListaTimerSavedRow(element: element)
            }
        }
    }
}

struct ListaTimerModifica_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ListaTimerModifica()
                .previewDevice("Apple Watch Series 6 - 44mm")
            
            ListaTimerModifica()
                .previewDevice("Apple Watch Series 6 - 40mm")
        }
        .environmentObject(UserData())
    }
}
