//
//  ApiManager.swift
//  Yandex Stocks
//
//  Created by Никита Казанцев on 28.03.2021.
//

import Foundation


class APIManager {
    
    static let sharedInstance = APIManager()
    
    private lazy var session: URLSession = {
        // Set In-Memory Cache to 512 MB
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024

        // Create URL Session Configuration
        let configuration = URLSessionConfiguration.ephemeral
       
        // Define Request Cache Policy
        configuration.requestCachePolicy = .useProtocolCachePolicy

        return URLSession(configuration: configuration)
    }()
    
    let urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
    
    private let apiKey: String = "bvatnf748v6ser00knvg"
    
    private lazy var lastTimeCacheUpdated: Date = {
        let defaults = UserDefaults.standard
        
        if UserDefaults.standard.object(forKey: "cache") != nil {
             // userDefault has a value
            return Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "cache"))
            } else {
             // userDefault is nil (empty)
                return Date().addingTimeInterval(36000)
            }
    }()
    
    func postRequest<T: Decodable>(modelType: T.Type, url: String,  parameters: [String: Any], completion : @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url + "&token=\(APIManager.sharedInstance.apiKey)") else {return}
        

        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        do {
            let httpBodyWithParameters = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = httpBodyWithParameters
            
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    let cachedURLResponse = CachedURLResponse(response: response!, data: data!, userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "cache")
                    completion( Result { try JSONDecoder().decode(T.self, from: data!)})
                    return
                }
            }.resume()
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func getRequest<T: Decodable>(modelType: T.Type, url: String, completion : @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url + "&token=\(APIManager.sharedInstance.apiKey)") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
        
        // еще не прошло достаточно времени, чтоб обновить кэш
        if abs(lastTimeCacheUpdated.timeIntervalSince(Date())) <= 3 * 60 {
        if let cacheResponse = urlCache.cachedResponse(for: request) {
            
            completion( Result { try JSONDecoder().decode(T.self, from: cacheResponse.data)})
            print("CACHE USED")
            return
                }
        }
        
        // реальная загрузка. не кэш
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                print("NOT CACHE")
                let cacheResponse = CachedURLResponse(response: response!, data: data!)
                self.urlCache.storeCachedResponse(cacheResponse, for: request)
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "cache")
                completion( Result { try JSONDecoder().decode(T.self, from: data!)})
                return
            }
        }.resume()
        
    }
    
    
}


