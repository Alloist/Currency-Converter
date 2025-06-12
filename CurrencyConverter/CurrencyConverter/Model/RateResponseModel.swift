//
//  RateResponseModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation


struct RateResponseData: Codable {
    let data: [String: RateResponseModel]
}


struct RateResponseModel: Codable {
    let code: String
    let rate: Double
}
