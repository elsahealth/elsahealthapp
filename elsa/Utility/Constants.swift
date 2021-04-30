//
//  Constants.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-18.
//

import SwiftUI

// LAYOUT
var rowSpacing: CGFloat = 10
var gridLayout: [GridItem] {
    return Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 2)
}


// TO BE DELETED
let offering: [Offerings] = Bundle.main.decode("offerings.json")
