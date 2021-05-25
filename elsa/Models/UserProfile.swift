//
//  UserProfile.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct UserProfile : Codable {
    var uid: String
    var firstName : String
    var lastName : String
    var email : String
}
