//
//  Cards.swift
//  InstantMatch
//
//  Created by Halil Yuce on 15.11.2020.
//

import UIKit

// MARK: - Cards
struct Cards: Codable {
    let list: [Card]?
}

// MARK: - Liste
struct Card: Codable {
    let images: [String]?
    let _id, username, name, email, birthDate: String?
    let gender, lookingFor: Int?
    
    /// Card x position
    var x: CGFloat? = 0.0
    /// Card y position
    var y: CGFloat? = 0.0
    /// Card rotation angle
    var degree: Double? = 0.0
    /// Card image index
    var index: Int? = 0
    
}

// MARK: - Swipe
struct Swipe: Codable {
    let isSuccess: Bool?
}
