//
//  ListaTimerRow.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import UserNotifications

struct ListaTimerRow: View {
    @State var element : ListElement
    @State var notification: UNNotificationRequest
    var body: some View {
        TextField(notification.content.body, text: $element.description)
            .textFieldStyle(.plain)
    }
}


