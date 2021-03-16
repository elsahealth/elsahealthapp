//
//  PillReminder.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-15.
//

import SwiftUI

struct PillReminder: View {
    @State private var reminder = Date()
    @State private var reminderMessage: String = ""
    var body: some View {
        VStack {
            Text("What time would you like to receive a pill reminder?")
                //.lineLimit(nil)
            Text("Choose any preferred time, but keep it consistent")
            
            DatePicker("Please enter a date", selection: $reminder, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Text("What would you like your reminder message to say?")
            Text("Choose your personalized reminder message")
                .font(.caption2)
            
            TextField("Pill Time ! etc...", text: $reminderMessage)
            
            HStack {
                VStack {
                    Text("Sleep")
                    Image(systemName: "powersleep")
                }
                VStack {
                    Text("Music")
                    Image(systemName: "music.note")
                }
                //TODO: Complete the implementation
            }
            Text("Save")
            Text("No thanks")
        }


    }
}

struct PillReminder_Previews: PreviewProvider {
    static var previews: some View {
        PillReminder()
    }
}

