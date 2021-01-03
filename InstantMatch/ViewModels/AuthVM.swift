//
//  AuthVM.swift
//  InstantMatch
//
//  Created by Halil Yuce on 21.11.2020.
//

import Foundation

enum Status {
    case ready
    case loading
    case parseError
    case noLocation
    case done
}

class AuthVM: ObservableObject {
    
    @Published var token = ""
    @Published var error = false
    @Published var errorDesc = ""
    @Published var errorType = ""
    @Published var loggedIn = false
    @Published var status = Status.ready
    @Published var registerStatus = Status.ready
    
//  Login Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    
//  Register Inputs
    let genders = ["MALE", "FEMALE", "OTHER"]
    let lookingfor = ["MALE", "FEMALE", "BOTH"]
    
    @Published var register_username: String = ""
    @Published var register_password: String = ""
    @Published var register_name: String = ""
    @Published var register_email: String = ""
    @Published var register_gender: Int = 0
    @Published var register_birthday: Date = Date()
    @Published var register_lookingfor: Int = 1
    
    private init() { }
    
    static let shared = AuthVM()
    
    
    func login() {
        self.status = .loading
        ApiManager.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.status = .done
                self.token = "Bearer " + (result.authToken ?? "")
                UserDefaults.standard.set("Bearer " + (result.authToken ?? ""), forKey: "token")
                UserDefaults.standard.set(result.user?._id ?? 0, forKey: "userID")
                try? UserDefaults.standard.setCustomObject(result.user, forKey: "user")
                self.loggedIn = true
            case .failure(_):
                print("error")
                self.status = .parseError
                self.error.toggle()
                self.errorDesc = NSLocalizedString("Please check your credentials and try again.", comment: "")
                self.errorType = "Login"
            }
        }
    }
    
    func logOut(){
        self.loggedIn = false
        UserDefaults.standard.set(nil, forKey: "token")
        UserDefaults.standard.set(nil, forKey: "userID")
        UserDefaults.standard.set(nil, forKey: "user")
    }
    
    func register(){
        self.registerStatus = .loading
        ApiManager.shared.register(username: register_username, name: register_name, email: register_email, password: register_password, birthDate: register_birthday.toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"), gender: register_gender, lookingFor: register_lookingfor) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.registerStatus = .done
                self.token = "Bearer " + (result.authToken ?? "")
                UserDefaults.standard.set("Bearer " + (result.authToken ?? ""), forKey: "token")
                UserDefaults.standard.set(result.user?._id ?? 0, forKey: "userID")
                try? UserDefaults.standard.setCustomObject(result.user, forKey: "user")
                self.loggedIn = true
            case .failure(_):
                print("error")
                self.registerStatus = .parseError
                self.error.toggle()
                self.errorDesc = "Please check your information."
                self.errorType = "Register"
            }
        }
    }
    
}
