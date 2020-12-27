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
    let loginURL = "/user/login"
    
    
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
    
}
