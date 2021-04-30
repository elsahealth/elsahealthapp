//
//  OfferingsItemView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-25.
//

import SwiftUI

struct OfferingsItemView: View {
  // MARK: - PROPERTY
  
  let offering: Offerings
  
  // MARK: - BODY
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6, content: {
      // PHOTO
      ZStack {
        Image(offering.photo)
          .resizable()
          .scaledToFit()
          .padding(10)
      } //: ZSTACK
      .cornerRadius(12)
      
      // NAME
      Text(offering.name)
        .font(.title3)
        .fontWeight(.black)
      
      // PRICE
      Text(offering.formattedPrice)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
    }) //: VSTACK
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

