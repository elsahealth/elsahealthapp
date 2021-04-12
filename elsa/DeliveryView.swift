//
//  DeliveryView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-17.
//

import SwiftUI
import Stripe

struct DeliveryView: View {
    var body: some View {
        NavigationLink(destination: PaymentView()) {
            Text("Payment View")
        }
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
