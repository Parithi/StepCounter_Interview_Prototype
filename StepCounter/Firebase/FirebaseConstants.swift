//
//  FirebaseConstants.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-23.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import Foundation

enum Collections : String {
    case profiles = "profiles"
}

public struct Profile : Codable {

    var profilePictureUrl: String? = nil
    var lastLoggedIn: Int64? = nil
    var name: String? = nil
    var email: String? = nil

    enum CodingKeys: String, CodingKey {
        case profilePictureUrl = "profile_profile_url"
        case lastLoggedIn = "last_logged_in"
        case name = "name"
        case email = "email"
    }

}
