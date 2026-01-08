//
//  CustomStopsView.swift
//  Speech WatchKit Extension
//
//  Created by Valentino Palomba on 23/01/2020.
//  Copyright © 2020 Valentino Palomba. All rights reserved.
//

import SwiftUI
import Combine

struct CustomStopsView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State private var listElements = [ListElement(description: "")]
    
    var body: some View {
        VStack {
            Text("Customize the stops")
                .padding(.top, 10)
            
            List {
                ForEach(0..<timerViewModel.notificationRequests.count, id: \.self) { index in
                     ForEach(listElements, id: \.id){ element in
                        CustomStopRow(element: element)
                    }
                }
            }
            
            HStack(spacing: 10) {
                Button(action: {
                    timerViewModel.navigate(to: .timerActive)
                }) {
                    Text("Skip")
                }
                .tint(.gray)

                Button(action: {
                    timerViewModel.navigate(to: .timerActive)
                }) {
                    Text("Next")
                }
                .tint(.blue)
            }
        }
        .navigationTitle("Stops")
    }
}

struct CustomStopsView_Previews: PreviewProvider {
    static var previews: some View {
        Group(){
            CustomStopsView()
                .previewDevice("Apple Watch Series 6 - 44mm")
            CustomStopsView()
                .previewDevice("Apple Watch Series 6 - 40mm")
        }
        .environmentObject(TimerViewModel())
    }
}