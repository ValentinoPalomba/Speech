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
        ListElementSaved(name: "Academy", timerString: "2:00", timerDouble: 2.00),
        ListElementSaved(name: "Presentazione", timerString: "8:00", timerDouble: 8.00),
        ListElementSaved(name: "TedX", timerString: "18:00", timerDouble: 18.00),
        ListElementSaved(name: "Speech", timerString: "10:00", timerDouble: 10.00)
    ]
}
