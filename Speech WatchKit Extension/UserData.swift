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
        ListElementSaved(name: "Timer1", timerString: "2:00", timerDouble: 2.00),
        ListElementSaved(name: "Timer2", timerString: "8:00", timerDouble: 8.00),
        ListElementSaved(name: "Timer3", timerString: "18:00", timerDouble: 18.00),
        ListElementSaved(name: "Timer4", timerString: "10:00", timerDouble: 10.00)
    ]
    
    static let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([ListElementSaved].self, from: data) {
                self.listElementsSaved = decoded
                return
            }
        }

        self.listElementsSaved = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(listElementsSaved) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}
