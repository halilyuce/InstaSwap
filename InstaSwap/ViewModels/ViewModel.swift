//
//  ViewModel.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var data: [Card] = [
        Card(id:1, name: "Rosie", country: "USA", images: ["gigi", "hadid", "gigihadid"], age: 21, bio: "Insta - roooox 💋"),
        Card(id:2, name: "Betty", country: "UK", images: ["hadid"], age: 23, bio: "Like exercising, going out, pub, working 🍻"),
        Card(id:3, name: "Abigail", country: "Turkey", images: ["gigihadid", "hadid"], age: 26, bio: "hi, let's be friends"),
        Card(id:4, name: "Zoé", country: "Israel", images: ["gigi"], age: 20, bio: "Law grad"),
        Card(id:5, name: "Tilly", country: "Turkey", images: ["gigi"], age: 21, bio: "Follow me on IG"),
        Card(id:6, name: "Penny", country: "Iran", images: ["gigi"], age: 24, bio: "J'aime la vie et le vin 🍷"),
        Card(id:7, name: "Arianne", country: "USA", images: ["gigi"], age: 23, bio: "🇬🇧 22, uni of Notts"),
        Card(id:8, name: "Sam", country: "UK", images: ["gigi"], age: 22, bio: "S.Wales / Oxford 📚"),
    ]
    
    private init() { }
    
    static let shared = ViewModel()
    
}
