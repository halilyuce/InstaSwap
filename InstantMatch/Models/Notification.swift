//
//  Notification.swift
//  InstantMatch
//
//  Created by Halil Yuce on 3.01.2021.
//

import Foundation

// MARK: - Welcome
struct WelcomeNotification: Codable{
    let list: [Notification]
}

// MARK: - List
struct Notification: Codable {
    let id: String
    let user: User?
    let notificationType: Int?
    let date: String?
    
    var isshowed: Bool? = false
}
