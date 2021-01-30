//
//  ApiManager.swift
//  tinkoffStocks
//
//  Created by Никита Казанцев on 30.01.2021.
//

import Foundation


class APIManager {
    
    static let sharedInstance = APIManager()
    
    
    let session = URLSession.shared
    let apiKey: String = "bvatnf748v6ser00knvg"
    
    func postRequest<T: Decodable>(modelType: T.Type, url: String,  parameters: [String: Any], completion : @escaping (Result<T, Error>) -> Void) {
            guard let url = URL(string: url) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let httpBodyWithParameters = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = httpBodyWithParameters
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion( Result { try JSONDecoder().decode(T.self, from: data!)})
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    
    func getRequest<T: Decodable>(modelType: T.Type, url: String, completion : @escaping (Result<T, Error>) -> Void) {
            guard let url = URL(string: url) else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let datastring = String(bytes: data!, encoding: String.Encoding.utf8)
                        print(datastring)
                        print("\n\n\n\n\n\n\n")
                        completion( Result { try JSONDecoder().decode(T.self, from: data!)})
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    
}
