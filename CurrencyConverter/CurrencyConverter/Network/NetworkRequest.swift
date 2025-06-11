//
//  NetworkRequest.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

struct NetworkRequest {
    let urlString: String
    let method: HTTPMethod
    let body: Codable?
    let headers: [String: String]
    
    init(urlString: String,
         method: HTTPMethod,
         body: Codable?,
         headers: [String: String] = [:]) {
        self.urlString = urlString
        self.method = method
        self.body = body
        self.headers = headers
    }
    
    func getUrlRequest() throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            debugPrint(ErrorList.invalidURL)
            throw ErrorList.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                debugPrint(error)
                throw error
            }
        }
        
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
