//
//  APIManager.swift
//  InstantMatch
//
//  Created by Halil Yuce on 27.12.2020.
//
import Foundation
import SwiftUI

class ApiManager {
    static let shared = ApiManager()
    
    private init() { }
    
    let baseURL = "https://api.labters.com/api/"
    let loginURL = "user/login"
    let registerURL = "user/register"
    let doubletakeURL = "main/doubleTake"
    let postSwipeURL = "main/postSwipe"
    let notificationsURL = "notifications"
    let settingsUserURL = "settings/user"
    let photosURL = "settings/postPhotos"
    
    func login(email:String, password:String, completion: @escaping (Result<Welcome, Error>) -> Void) {
        
        let url = baseURL + loginURL
        
        let params =  ["email": email, "password": password] as [String : Any]
        
        HttpManager.shared.post(URL(string: url)!, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(Welcome.self, from: data)
                    DispatchQueue.main.async { completion(.success(token)) }
                } catch {
                    print("Unable to retrieve string representation")
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    func register(username:String, name:String, email:String, password:String, birthDate:String, gender: Int, lookingFor:Int, completion: @escaping (Result<Welcome, Error>) -> Void) {
        
        let url = baseURL + registerURL
        
        let params =  [
            "username": username,
            "name": name,
            "email": email,
            "password": password,
            "birthDate": birthDate,
            "gender": gender,
            "lookingFor": lookingFor
        ] as [String : Any]
        
        HttpManager.shared.post(URL(string: url)!, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(Welcome.self, from: data)
                    DispatchQueue.main.async { completion(.success(token)) }
                } catch {
                    print("Unable to retrieve string representation")
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    func doubleTake(completion: @escaping (Result<Cards, Error>) -> Void) {
        
        let url = baseURL + doubletakeURL
        
        HttpManager.shared.post(URL(string: url)!, parameters: nil) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let cards = try JSONDecoder().decode(Cards.self, from: data)
                    DispatchQueue.main.async { completion(.success(cards)) }
                } catch {
                    print("Failed to decode standings from bundle: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func postSwipe(userId:String, isLiked: Bool, completion: @escaping (Result<Swipe, Error>) -> Void) {
        
        let url = baseURL + postSwipeURL
        let params =  ["userId": userId, "isLiked": isLiked] as [String : Any]
        
        HttpManager.shared.post(URL(string: url)!, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let bool = try JSONDecoder().decode(Swipe.self, from: data)
                    DispatchQueue.main.async { completion(.success(bool)) }
                } catch {
                    print("Failed to decode standings from bundle: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getNotifications(page:Int, completion: @escaping (Result<WelcomeNotification, Error>) -> Void) {
        
        let url = baseURL + notificationsURL + "?page=\(page)"
        
        HttpManager.shared.get(URL(string: url)!, token: nil) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(WelcomeNotification.self, from: data)
                    DispatchQueue.main.async { completion(.success(token)) }
                } catch {
                    print("Unable to retrieve string representation")
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    func patchNotification(id:String, type: Int, completion: @escaping (Result<WelcomeNotification, Error>) -> Void) {
        
        let url = baseURL + notificationsURL
        let params =  ["notificationId": id, "type": type] as [String : Any]
        
        HttpManager.shared.post(URL(string: url)!, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let bool = try JSONDecoder().decode(WelcomeNotification.self, from: data)
                    DispatchQueue.main.async { completion(.success(bool)) }
                } catch {
                    print("Failed to decode standings from bundle: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateUser(name:String?, username:String?, birthDate:String?, gender: Int?, lookingFor:Int?, completion: @escaping (Result<WelcomeUser, Error>) -> Void) {
        
        let url = baseURL + settingsUserURL
        var params: [String : Any] = [:]
        
        if name != nil{
            params = ["name": name!]
        }
        
        if username != nil{
            params = ["username": username!]
        }
        
        if birthDate != nil{
            params = ["birthDate": birthDate!]
        }
        
        if gender != nil{
            params = ["gender": gender!]
        }
        
        if lookingFor != nil{
            params = ["lookingFor": lookingFor!]
        }
        
        HttpManager.shared.patch(URL(string: url)!, token: nil, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let bool = try JSONDecoder().decode(WelcomeUser.self, from: data)
                    DispatchQueue.main.async { completion(.success(bool)) }
                } catch {
                    print("Failed to decode standings from bundle: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let url = baseURL + settingsUserURL
        
        HttpManager.shared.delete(URL(string: url)!, token: nil) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(_):
                DispatchQueue.main.async { completion(.success(true)) }
            }
        }
    }
    
    func postPhotos(images:[UserImages], completion: @escaping (Result<WelcomeUser, Error>) -> Void) {
        
        let url = baseURL + photosURL
        
        var imagesArray:Array<Dictionary<String, String?>> = Array()
        
        for image in images {
            imagesArray.append(["imageURL": nil, "base64": image.base64!])
        }
    
        let params =  ["images": imagesArray] as [String : Any]
        
        HttpManager.shared.post(URL(string: url)!, parameters: params) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let data):
                do {
                    let bool = try JSONDecoder().decode(WelcomeUser.self, from: data)
                    DispatchQueue.main.async { completion(.success(bool)) }
                } catch {
                    print("Failed to decode standings from bundle: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
