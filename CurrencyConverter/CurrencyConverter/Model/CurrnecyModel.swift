//
//  CurrnecyModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation

struct CurrencyModel: Codable {
    var id = UUID().uuidString
    let model: CurrencyResponseModel
    let rate: [RateResponseModel]
}
