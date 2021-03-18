//
//  PrescriptionViewYesPreScan.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-17.
//

import SwiftUI

struct PrescriptionViewYesPreScan: View {
    var body: some View {
        VStack {
            Text("I already have a prescription")
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("elsaYellow1"))
                    .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 2)
                VStack {
                    Text("Scan your prescription")
                    Image("prescriptionYesScanQRcode")
                    NavigationLink(destination: PrescriptionViewYesScan()) {
                        Text("Scan")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("elsaBlue2"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct PrescriptionViewYesPreScan_Previews: PreviewProvider {
    static var previews: some View {
        PrescriptionViewYesPreScan()
    }
}
