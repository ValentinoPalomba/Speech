//
//  ListaTimerRow.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListaTimerRow: View {
    @State var element : ListElement
    
    var body: some View {
        VStack{
            TextField("Enter stop name", text: $element.description)
        }
        .frame(width: 160, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(12)
    }
}

struct ListaTimerRow_Previews: PreviewProvider {
    static var previews: some View {
        ListaTimerRow(element: UserData().listElements[0])
    }
}

