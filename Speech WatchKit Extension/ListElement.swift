//
//  ListElement.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI

struct ListElement: Hashable {
    var id = UUID()
    var description : String
    var isActive : Bool = false
}

struct ListElementSaved: Hashable {
    var id = UUID()
    var name : String
    var timer : String
    var isActive : Bool = false
}
