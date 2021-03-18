//
//  PrescriptionView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-17.
//

import SwiftUI

struct PrescriptionView: View {
    var body: some View {
        VStack {
            Text("Do you already have a prescription")
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("elsaYellow1"))
                    .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 3)
                VStack {
                    Text("I already have a prescription")
                    Text("Scan your prescription")
                        .font(.caption)
                    NavigationLink(
                        destination: PrescriptionViewYesPreScan(),
                        label: {
                            Text("Start")
                                .padding(/*@START_MENU_TOKEN@*/.all, 5.0/*@END_MENU_TOKEN@*/)
                                .background(Color("elsaBlue2"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("elsaYellow1"))
                    .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 3)
                VStack {
                    Text("I need a prescription")
                    Text("Complete elsa Health questionnaire")
                        .font(.caption)
                    NavigationLink(
                        destination: PrescriptionViewNoSurvey(),
                        label: {
                            Text("Start")
                                .padding(/*@START_MENU_TOKEN@*/.all, 5.0/*@END_MENU_TOKEN@*/)
                                .background(Color("elsaBlue2"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                }
            }
        }
    }
}

struct PrescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PrescriptionView()
    }
}
