//
//  CustomStopRow.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct CustomStopRow: View {
    @State var element : ListElement
    
    var body: some View {
        VStack{
            TextField("Enter stop name", text: $element.description)
        }
        .frame(width: 160, height: 50, alignment: .center).cornerRadius(12)
    }
}

struct CustomStopRow_Previews: PreviewProvider {
    static var previews: some View {
        CustomStopRow(element: ListElement(description: "Test"))
    }
}