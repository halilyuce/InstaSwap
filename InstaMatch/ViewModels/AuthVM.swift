//
//  AuthVM.swift
//  InstaMatch
//
//  Created by Halil Yuce on 21.11.2020.
//

import Foundation

class AuthVM: ObservableObject {
    
//  Login Inputs
    @Published var username: String = ""
    @Published var password: String = ""
    
//  Register Inputs
    let genders = ["Male", "Female", "Others"]
    let lookingfor = ["Male", "Female", "Both"]
    
    @Published var register_username: String = ""
    @Published var register_password: String = ""
    @Published var register_name: String = ""
    @Published var register_email: String = ""
    @Published var register_gender: Int = 0
    @Published var register_birthday: Date = Date()
    @Published var register_lookingfor: Int = 1
    
    private init() { }
    
    static let shared = AuthVM()
    
}
