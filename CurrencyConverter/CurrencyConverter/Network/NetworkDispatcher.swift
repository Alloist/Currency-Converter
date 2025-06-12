//
//  NetworkDispatcher.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import Combine

enum ErrorList: Error {
    case custom(message: String)
    
    case invalidURL
    case urlSessionFailed
    case noData
    case decodingFailed
    case unknownServerError
}

protocol NetworkDispatcher {
    static func dispatch<T: Codable>(request: NetworkRequest) -> AnyPublisher<T, Error>
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    
    static func dispatch<T>(request: NetworkRequest) -> AnyPublisher<T, Error> where T: Codable {
        
        var urlRequest: URLRequest
        
        do {
            urlRequest = try request.getUrlRequest()
        } catch {
            let subj = PassthroughSubject<T, Error>()
            subj.send(completion: .failure(error))
            return subj.eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw ErrorList.unknownServerError
                }
//                debugPrint(String(data: output.data, encoding: .utf8)!)
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                ErrorList.decodingFailed
            }
            .eraseToAnyPublisher()
    }
    
}
