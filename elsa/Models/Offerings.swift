//
//  Offerings.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-18.
//

import Foundation
import FirebaseFirestoreSwift

struct Offerings : Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var price: Int
    var photo: URL
    
    var formattedPrice: String { return "$\(price/100)" }
    
    //Use this struct if we want to have a name to match what is in firebase without needing to change all of the code
    enum CodingKeys: String, CodingKey {
        //Example
        // name of variable in code = name of variable in firebase
        // case name = "name of product"
        case name
        case description
        case price
        case photo
    }
}
