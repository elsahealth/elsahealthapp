//
//  OfferingsItemView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OfferingsItemView: View {  
    let offering: Offerings
  
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            // PHOTO
            ZStack {
                WebImage(url: offering.photo)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
            .cornerRadius(12)
      
            // NAME
            Text(offering.name)
                .font(.title3)
                .fontWeight(.black)
      
            // PRICE
            Text(offering.formattedPrice)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
    })
  }
}

// MARK: - PREVIEW

struct ProductItemView_Previews: PreviewProvider {
  static var previews: some View {
    OfferingsItemView(offering: offering[0])
      .previewLayout(.fixed(width: 200, height: 300))
      .padding()
  }
}

