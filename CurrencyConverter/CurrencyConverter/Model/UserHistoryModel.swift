//
//  UserHistoryModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation

struct UserHistoryModel: Codable {
    var id = UUID().uuidString
    let date: String
    let from: String
    let to: String
}
