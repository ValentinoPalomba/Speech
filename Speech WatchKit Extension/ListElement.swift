//
//  ListElement.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListElement: Hashable, Codable, Identifiable {
    var id = UUID()
    var description : String
    var isActive : Bool = false
}

struct ListElementSaved: Hashable, Codable, Identifiable {
    var id = UUID()
    var name : String
    var timerString : String
    var timerDouble : Double
    var isActive : Bool = false
}

struct ListTimerSaved: Hashable, Codable, Identifiable{
    var id = UUID()
    var name : String
    var timerString : String
    var timerDouble : String
    var isActive : Bool = false
}
