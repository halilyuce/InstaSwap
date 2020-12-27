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
    
//  Login Inputs
    @Published var email: String = ""
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
    
    
    func login(email: String, password: String) {
        self.status = .loading
        ApiManager.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.status = .done
                self.token = "Bearer " + (result.authToken ?? "")
                UserDefaults.standard.set("Bearer " + (result.authToken ?? ""), forKey: "token")
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
    
}
