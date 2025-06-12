//
//  CurrencyNetworkManager.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import Combine

protocol CyrrencuNetworkProtocol {
    func getCurrencies() -> AnyPublisher<CurrencyResponseData, Error>
    func getExchangeRate(from code: String) //-> AnyPublisher<RateResponseData, Error>
}

final class CurrencyNetworkManager: CyrrencuNetworkProtocol {
    
    func getCurrencies() -> AnyPublisher<CurrencyResponseData, Error> {
        let headers = [HTTPConstants.Headers.Keys.contentType: HTTPConstants.Headers.Values.applicationJSON]
        
        let urlString = String(format: APIConstants.currencies.rawValue,
                               APIConstants.apiKey.rawValue,
                               SupportedCurrencyCode.allCases.map(\.rawValue).joined(separator: ","))
        
        let request = NetworkRequest(urlString: urlString,
                                     method: .get,
                                     body: nil,
                                     headers: headers)
        return URLSessionNetworkDispatcher.dispatch(request: request)
    }
    
    func getExchangeRate(from code: String) {
        let headers = [HTTPConstants.Headers.Keys.contentType: HTTPConstants.Headers.Values.applicationJSON]
        
        var outOffArray = SupportedCurrencyCode.allCases

        if let fromCurrency = SupportedCurrencyCode(rawValue: code.uppercased()),
           let index = outOffArray.firstIndex(of: fromCurrency) {
            outOffArray.remove(at: index)
        }
        
        let urlString = String(format: APIConstants.currencies.rawValue,
                               APIConstants.apiKey.rawValue,
                               outOffArray.map(\.rawValue).joined(separator: ","))
        
    }
}
