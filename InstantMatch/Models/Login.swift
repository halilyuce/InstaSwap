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
    let images: [String]?
    let _id, username, name, email, birthDate: String?
    let gender, lookingFor: Int?
}
