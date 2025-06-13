//
//  CurrencyNetworkManager.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation

protocol CurrencyNetworkProtocol {
    /// return 'async throws -> CurrencyResponseData'
    func getCurrencies() async throws -> CurrencyResponseData
    /// return  'async throws -> RateResponseData'
    func getExchangeRate(from code: String) async throws -> RateResponseData
}

final class CurrencyNetworkManager: CurrencyNetworkProtocol {
    
    func getCurrencies() async throws -> CurrencyResponseData {
        let headers = [HTTPConstants.Headers.Keys.contentType: HTTPConstants.Headers.Values.applicationJSON]
        
        let urlString = String(format: APIConstants.currencies.rawValue,
                               APIConstants.apiKey.rawValue,
                               SupportedCurrencyCode.allCases.map(\.rawValue).joined(separator: ","))
        
        let request = NetworkRequest(urlString: urlString,
                                     method: .get,
                                     body: nil,
                                     headers: headers)
        
        return try await URLSessionNetworkDispatcher.dispatch(request: request)
    }
    
    /// return  'async throws -> RateResponseData'
    func getExchangeRate(from code: String) async throws -> RateResponseData {
        let headers = [HTTPConstants.Headers.Keys.contentType: HTTPConstants.Headers.Values.applicationJSON]
        
        var outOffArray = SupportedCurrencyCode.allCases

        if let fromCurrency = SupportedCurrencyCode(rawValue: code.uppercased()),
           let index = outOffArray.firstIndex(of: fromCurrency) {
            outOffArray.remove(at: index)
        }
        
        let urlString = String(format: APIConstants.latest.rawValue,
                               APIConstants.apiKey.rawValue,
                               outOffArray.map(\.rawValue).joined(separator: ","),
                               code.uppercased())
        
        let request = NetworkRequest(urlString: urlString,
                                     method: .get,
                                     body: nil,
                                     headers: headers)
        
        return try await URLSessionNetworkDispatcher.dispatch(request: request)
    }
    
}
