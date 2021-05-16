//
//  PillReminderView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-15.
//

import SwiftUI
import UserNotifications

struct PillReminderView: View {
    @State private var reminderDate = Date()
    @State private var reminderMessage: String = ""
    @State private var isSaved = false
    var dateComponents = DateComponents()
    
    var body: some View {
        VStack {
            Text("What time would you like to receive a pill reminder?")
                //.lineLimit(nil)
            Text("Choose any preferred time, but keep it consistent")
            
            DatePicker("Please enter a time", selection: self.$reminderDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
            Text("What would you like your reminder message to say?")
            Text("Choose your personalized reminder message")
                .font(.caption2)
            
            TextField("Pill Time ! etc...", text: self.$reminderMessage)
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width - 30, height: 40)
                .background(Color.black.opacity(0.1))
                .clipShape(Capsule())
                
            
            HStack {
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    VStack {
                    Text("Sleep")
                    Image(systemName: "powersleep")
                    //TODO: Complete the implementation
                    }
                    .padding()
                }
                Button (action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    VStack {
                        Text("Music")
                        Image(systemName: "music.note")
                    }
                    .padding()
                    //TODO: Complete the implementation
                }
            }
            NavigationLink(destination: HomeView(), isActive: $isSaved) { EmptyView() }
                Button(action: {
                    // Allowing the permissions
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("Notification permissions have been set")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // Creating the notification message
                    let content = UNMutableNotificationContent()
                        content.title = "elsa"
                        content.subtitle = "Pill Reminder"
                        content.body = reminderMessage
                        content.sound = UNNotificationSound.default
                    
                    // Media for the notification
    //                let imageName = "applelogo"
    //                guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else
    //
    //                let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
    //
    //                content.attachments = [attachment]
                    
                    // Notification cadence
                    //dateComponents.hour = reminder.
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: reminderDate), repeats: true)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    
                    //Go back to the home page
                    self.isSaved = true
                }, label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("elsaBlue2"))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                })
            
            //TODO: implement error handling potentially
            
            
            
            NavigationLink(destination: HomeView()) {
                Text("No thanks")
            }
        }


    }
}

struct PillReminderView_Previews: PreviewProvider {
    static var previews: some View {
        PillReminderView()
    }
}

