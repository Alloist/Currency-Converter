//
//  CurrencyResponseModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

struct CurrencyResponseData: Codable {
    let data: [String: CurrencyResponseModel]
}

struct CurrencyResponseModel: Codable, Hashable, Identifiable {
    let id = UUID().uuidString
    let symbol: String
    let name: String
    let symbolNative: String
    let decimalDigits: Int
    let rounding: Int
    let code: String
    let namePlural: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding
        case code
        case namePlural = "name_plural"
        case type
    }
}
