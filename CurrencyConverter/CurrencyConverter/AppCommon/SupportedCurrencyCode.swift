//
//  SupportedCurrencyCode.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

enum SupportedCurrencyCode: String, CaseIterable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case chf = "CHF"
    case cny = "CNY"
    
    var description: String {
        switch self {
        case .rub: return "Russian Ruble"
        case .usd: return "US Dollar"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .chf: return "Swiss Franc"
        case .cny: return "Chinese Yuan"
        }
    }
    
}
