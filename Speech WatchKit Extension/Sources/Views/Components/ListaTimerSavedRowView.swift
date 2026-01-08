//
//  ListaTimerSavedRowView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerSavedRowView: View {
    @State var element : ListElementSaved
    var body: some View {
        HStack{
            Text(element.name)
            Spacer()
            Text(element.timerString)
        }
    }
}

struct ListaTimerSavedRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListaTimerSavedRowView(element: UserData().listElementsSaved[0])
    }
}
