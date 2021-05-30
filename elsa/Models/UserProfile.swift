//
//  UserProfile.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-16.
//

import Foundation

class UserProfileWrapper : ObservableObject {
    @Published var userProfile : UserProfile?
}

struct UserProfile : Codable {
    var uid: String = ""
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
}
