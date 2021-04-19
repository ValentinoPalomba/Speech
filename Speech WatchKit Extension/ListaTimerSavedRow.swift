//
//  ListaTimerSavedRow.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerSavedRow: View {
    @State var element : ListElementSaved
    var body: some View {
        HStack{
            Text(element.name)
            Spacer()
            Text(element.timerString)
        }
    }
}

struct ListaTimerSavedRow_Previews: PreviewProvider {
    static var previews: some View {
        ListaTimerSavedRow(element: UserData().listElementsSaved[0])
    }
}
