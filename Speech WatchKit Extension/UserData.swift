//
//  UserData.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import Combine
import SwiftUI


final class UserData: ObservableObject {
    
    @Published var listElements = [
        ListElement(description: "")
    ]
    
    @Published var listElementsSaved = [
        ListElementSaved(name: "Academy", timer: "2:00"),
        ListElementSaved(name: "Presentazione", timer: "8:00"),
        ListElementSaved(name: "TedX", timer: "18:00"),
        ListElementSaved(name: "Speech", timer: "10:00")
    ]
}
