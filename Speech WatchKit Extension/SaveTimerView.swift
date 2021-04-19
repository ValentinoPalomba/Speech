//
//  SaveTimerView.swift
//  Speech WatchKit Extension
//
//  Created by Girolamo Pinto on 18/04/21.
//  Copyright © 2021 Girolamo Pinto. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

struct SaveTimerView: View {
    @State var name : String
    @State var timerString : String
    @State var timerDouble : Double
    @EnvironmentObject var userData : UserData
    var body: some View {
        VStack{
            if #available(watchOSApplicationExtension 7.0, *) {
                Text("Save timer")
                    .font(.title2)
                    .padding(.top,15)
            } else {
                // Fallback on earlier versions
                Text("Save timer")
                    .font(.system(size: 30.0))
            }
            HStack{
                Text("Name :")
                TextField("Enter name", text: $name)
            }
            HStack{
                Text("Time   :")
                TextField("", text: $timerString)
            }
            
            Button(action: {}, label: {
                Text("Save")
            })
            .overlay(RoundedRectangle (cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2))
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.top,12)
            .environmentObject(UserData())
        }
    }
}

struct SaveTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SaveTimerView(name: "", timerString: "2.00", timerDouble: 2.00)
                .previewDevice("Apple Watch Series 6 - 44mm")
            
            SaveTimerView(name: "", timerString: "2.00", timerDouble: 2.00)
                .previewDevice("Apple Watch Series 6 - 40mm")
        }
        .environmentObject(UserData())
    }
}
