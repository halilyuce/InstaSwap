//
//  CustomError.swift
//  InstantMatch
//
//  Created by Halil Yuce on 3.01.2021.
//

import Foundation

// MARK: - Welcome
struct CustomError: Codable {
    let dialog: Dialog?
}

// MARK: - Dialog
struct Dialog: Codable {
    let errorCode: Int?
    let title: String?
    let cancelable: Bool?
    let description: String?
    let buttons: [Buttons]?
}

// MARK: - Button
struct Buttons: Codable{
    let actionCode: Int?
    let text: String?
}
