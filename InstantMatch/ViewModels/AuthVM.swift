//
//  AuthVM.swift
//  InstantMatch
//
//  Created by Halil Yuce on 21.11.2020.
//

import SwiftUI

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
    @Published var selectedTab: SelectedTab = .swaps
    @Published var status = Status.ready
    @Published var registerStatus = Status.ready
    @Published var deleteStatus = Status.ready
    @Published var updateStatus = Status.ready
    @Published var photoStatus = Status.ready
    
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
    
    @Environment(\.viewController) private var viewControllerHolder: ViewControllerHolder
    private var viewController: UIViewController? {
        self.viewControllerHolder.value
    }
    
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
                self.deviceId(id: UserDefaults.standard.string(forKey: "fcmtoken"), os: 0, auth: true)
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
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set(nil, forKey: "userID")
        UserDefaults.standard.set(nil, forKey: "user")
        self.deviceId(id: nil, os: nil, auth: true)
        
        self.viewController?.present(style: .fullScreen) {
            ContentView()
        }
        
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
                self.deviceId(id: UserDefaults.standard.string(forKey: "fcmtoken"), os: 0, auth: true)
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
    
    func updateUser(name: String? = nil, username: String? = nil, birthDate: String? = nil, gender: Int? = nil, lookingFor: Int? = nil, completion: @escaping (Bool) -> Void){
        self.updateStatus = .loading
        ApiManager.shared.updateUser(name: name, username: username, birthDate: birthDate, gender: gender, lookingFor: lookingFor) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.updateStatus = .done
                DispatchQueue.main.async { completion(true) }
            case .failure(_):
                print("error update user")
                self.updateStatus = .parseError
                DispatchQueue.main.async { completion(false) }
                self.error.toggle()
                self.errorDesc = NSLocalizedString("Please try again.", comment: "")
                self.errorType = "Update"
            }
        }
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void){
        self.deleteStatus = .loading
        ApiManager.shared.deleteUser() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.deleteStatus = .done
                DispatchQueue.main.async { completion(true) }
            case .failure(_):
                print("error delete user")
                self.deleteStatus = .parseError
                DispatchQueue.main.async { completion(false) }
                self.error.toggle()
                self.errorDesc = NSLocalizedString("Please try again.", comment: "")
                self.errorType = "Delete"
            }
        }
    }
    
    func postPhotos(images: [UserImages],completion: @escaping (Bool) -> Void){
        self.deleteStatus = .loading
        ApiManager.shared.postPhotos(images: images) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photoStatus = .done
                DispatchQueue.main.async { completion(true) }
            case .failure(_):
                print("error delete user")
                self.photoStatus = .parseError
                DispatchQueue.main.async { completion(false) }
                self.error.toggle()
                self.errorDesc = NSLocalizedString("Please try again.", comment: "")
                self.errorType = "Photos"
            }
        }
    }
    
    func deviceId(id: String? = nil, os:Int? = nil, auth: Bool){
        
        let oldfcmToken = UserDefaults.standard.string(forKey: "fcmtoken")
        let accessToken = UserDefaults.standard.string(forKey: "token")
        
        if (accessToken != nil){
            if auth{
                ApiManager.shared.postDeviceId(id: id, os: os) { _ in
                }
            }else{
                if id != oldfcmToken {
                    ApiManager.shared.postDeviceId(id: id, os: os) { _ in
                    }
                }
            }
        }
    }
    
}
