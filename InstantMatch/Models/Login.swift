//
//  Login.swift
//  InstantMatch
//
//  Created by Halil Yuce on 27.12.2020.
//

import Foundation

struct Welcome : Codable{
    let authToken: String?
    let user: User?
}

// MARK: - User
struct User : Codable{
    var images: [String]?
    var _id, username, name, email, birthDate: String?
    var gender, lookingFor: Int?
}
