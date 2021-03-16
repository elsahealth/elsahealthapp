//
//  Home.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-05.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        VStack {
            // insert profile button on the top right corner
            // figure out how to change the name
            Text("Good morning, Emy")
            Text("How can elsa help you today?")
            HStack {
                VStack {
                    Text("Prescription")
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("elsaYellow1"))
                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3)
                        Image("home_prescription")
                            //.resizable()
                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3)
                    }
                    Text("Fill our survey")
                        .font(.caption2)
                    Text("Get validated by an MD")
                        .font(.caption2)
                    Text("Dialogue with an MD")
                        .font(.caption2)
                    
                    // button to go to new view
                }
                VStack {
                    Text("Delivery")
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("elsaYellow2"))
                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3)
                        Image("home_delivery")
                            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3)
                    }
                    Text("Choose your delivery method")
                        .font(.caption2)
                        //.lineLimit(nil)
                    //TODO: Fix how it gets cut off
                    Text("Track delivery status")
                        .font(.caption2)
                }
            }
            Spacer()
            NavigationLink(destination: PillReminder()) {
                Text("Pill Reminder")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("elsaBlue2"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                //Image("home_bell")
                //TODO: Figure out how to add the bell to the right of Pill Reminder
            }
            Text("Learn more about contraceptives")
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("elsaBlue1"))
                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 4)
                // TODO: Figure out how to properly scale this rectangle
                HStack {
                    Image("home_g10")
                    VStack {
                        Text("Education")
                            .font(.subheadline)
                        Text("Learn more about birth control")
                            .font(.caption2)
                            //.lineLimit(nil)
                    }
                }
            }
            // Spacer()
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
