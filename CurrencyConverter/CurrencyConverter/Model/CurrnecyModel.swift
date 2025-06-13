//
//  CurrnecyModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation

struct CurrencyModel: Codable, Hashable {
    var id = UUID().uuidString
    let model: CurrencyResponseModel
    let rate: [String: Double]
}
