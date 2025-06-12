//
//  APIConstants.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

enum APIConstants: String {
    
    case apiKey = "fca_live_2TcrD1ook8HrqNygypV6wynCStBKwqnfslMhKhOt"
    
    case currencies = "https://api.freecurrencyapi.com/v1/currencies?apikey=%@&currencies=%@"
    case latest = "https://api.freecurrencyapi.com/v1/latest?apikey=%@&currencies=%@"
}
