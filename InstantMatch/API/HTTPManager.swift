//
//  HTTPManager.swift
//  InstantMatch
//
//  Created by Halil Yuce on 27.12.2020.
//

import Foundation
import UIKit

enum HttpError: Error {
    case invalidResponse(Data?, URLResponse?)
    case invalidStatusCode(Int)
    case apiError(Data)
    
    func get() -> Data {
        switch self {
        case .apiError(let val):
            return val
        case .invalidResponse(_, _):
            return Data()
        case .invalidStatusCode(_):
            return Data()
        }
    }
    
}

class HttpManager {
    static let shared = HttpManager()
    
    private init() { }
    
    public func patch(_ url: URL, token: String?, parameters: [String:Any]?, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        switch Locale.current.identifier {
        case "tr":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_US":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_TR":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "en":
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
        default:
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
            print("dil problemi var: " + Locale.current.identifier)
        }
        
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }else{
            request.setValue(UserDefaults.standard.object(forKey: "token") as? String ?? "", forHTTPHeaderField: "Authorization")
        }
        
        if parameters != nil{
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) else {
                return
            }
            request.httpBody = httpBody
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse
                else {
                    completionBlock(.failure(HttpError.invalidResponse(data, response)))
                    return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                completionBlock(.success(responseData))
            case 417:  // if there are others, add them to this list
                completionBlock(.failure(HttpError.apiError(data!)))
            default:
                completionBlock(.failure(HttpError.invalidStatusCode(httpResponse.statusCode)))
            }
            
        }
        task.resume()
        
    }
    
    public func delete(_ url: URL, token: String?, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        switch Locale.current.identifier {
        case "tr":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_US":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_TR":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "en":
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
        default:
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
            print("dil problemi var: " + Locale.current.identifier)
        }
        
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }else{
            request.setValue(UserDefaults.standard.object(forKey: "token") as? String ?? "", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse
                else {
                    completionBlock(.failure(HttpError.invalidResponse(data, response)))
                    return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                completionBlock(.success(responseData))
            case 417:  // if there are others, add them to this list
                completionBlock(.failure(HttpError.apiError(data!)))
            default:
                completionBlock(.failure(HttpError.invalidStatusCode(httpResponse.statusCode)))
            }
            
        }
        task.resume()
        
    }
    
    public func get(_ url: URL, token: String?, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        switch Locale.current.identifier {
        case "tr":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_US":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_TR":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "en":
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
        default:
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
            print("dil problemi var: " + Locale.current.identifier)
        }
        
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }else{
            request.setValue(UserDefaults.standard.object(forKey: "token") as? String ?? "", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse
                else {
                    completionBlock(.failure(HttpError.invalidResponse(data, response)))
                    return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                completionBlock(.success(responseData))
            case 417:  // if there are others, add them to this list
                completionBlock(.failure(HttpError.apiError(data!)))
            default:
                completionBlock(.failure(HttpError.invalidStatusCode(httpResponse.statusCode)))
            }
            
        }
        task.resume()
    }
    
    public func post(_ url: URL, parameters: [String:Any]?, image: UIImage? = nil, key: String? = nil, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        switch Locale.current.identifier {
        case "tr":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_US":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "tr_TR":
            request.setValue("tr-TR", forHTTPHeaderField: "Accept-Language")
        case "en":
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
        default:
            request.setValue("en-EN", forHTTPHeaderField: "Accept-Language")
            print("dil problemi var: " + Locale.current.identifier)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        
        if url.absoluteString != "https://api.labters.com/api/user/login" || url.absoluteString != "https://api.labters.com/api/user/register"{
            request.setValue(UserDefaults.standard.object(forKey: "token") as? String ?? "", forHTTPHeaderField: "Authorization")
        }
        
        
        if image != nil {
            let boundary = generateBoundary()
            guard let mediaImage = BodyMedia(withImage: image!, forKey: key!) else { return }
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let dataBody = createDataBody(usingParams: parameters, media: mediaImage, boundary: boundary)
            request.httpBody = dataBody
        } else {
            if parameters != nil{
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) else {
                    return
                }
                request.httpBody = httpBody
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse
                else {
                    completionBlock(.failure(HttpError.invalidResponse(data, response)))
                    return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                completionBlock(.success(responseData))
            case 417:
                completionBlock(.failure(HttpError.apiError(data!)))
            default:
                completionBlock(.failure(HttpError.invalidStatusCode(httpResponse.statusCode)))
            }
            
        }
        task.resume()
    }
    
}

func generateBoundary() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct BodyMedia {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/*"
        self.fileName = image.typeIdentifier ?? UUID().uuidString
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        self.data = data
    }
}

func createDataBody(usingParams params: [String:Any]?, media: BodyMedia?, boundary: String) -> Data {
    
    let lineBreak = "\r\n"
    var body = Data()
    
    if (params != nil) {
        params?.forEach { (key, value) in
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)")
            body.append(lineBreak)
        }
    }
    
    if let media = media {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.fileName)\"\(lineBreak)")
        body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
        body.append(media.data)
        body.append(lineBreak)
    }
    
    
    body.append("--\(boundary)--\(lineBreak)")
    
    return body
}

extension UIImage {
    var typeIdentifier: String? {
        cgImage?.utType as String?
    }
}
