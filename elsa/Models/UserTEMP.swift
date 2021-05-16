//
//  UserTEMP.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-16.
//

import Foundation
import FirebaseFirestoreSwift

struct UserTEMP : Identifiable {
    @DocumentID var id : String? = UUID().uuidString
    var firstName : String
    var lastName : String
    var email : String
}
