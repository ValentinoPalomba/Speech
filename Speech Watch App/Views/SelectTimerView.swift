//
//  SelectTimerView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import Combine

struct SelectTimerView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text("Choose timer")
                .font(.headline)
                .padding(.bottom, 10)
            
            List(timerViewModel.savedTimers, id: \.id){ element in
                Button(action: {
                    timerViewModel.selectedTime = element.timerDouble
                    timerViewModel.navigate(to: .setMilestones)
                }) {
                    SavedTimerRow(element: element)
                }
            }
        }
        .navigationTitle("Presets")
    }
}

struct SelectTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SelectTimerView()
                .previewDevice("Apple Watch Series 5 - 44mm")
            
            SelectTimerView()
                .previewDevice("Apple Watch Series 5 - 40mm")
        }
        .environmentObject(TimerViewModel())
    }
}