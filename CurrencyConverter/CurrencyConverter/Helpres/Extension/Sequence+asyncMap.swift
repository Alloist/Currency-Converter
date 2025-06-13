//
//  Sequence+asyncMap.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 13.06.25.
//

import Foundation

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
