//
//  Cards.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import UIKit

struct Card: Identifiable {
    let id: Int
    let name: String
    let country: String
    let images: [String]
    let age: Int
    let bio: String
    
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
    /// Card image index
    var index: Int = 0
}
