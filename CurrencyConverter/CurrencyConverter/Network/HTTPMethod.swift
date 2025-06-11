//
//  HTTPMethod.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HTTPConstants {
    enum Headers {
        enum Keys {
            static let apikey = "apikey"
            static let contentType = "Content-type"
        }
        enum Values {
            static let applicationJSON = "application/json"
        }
    }
}
