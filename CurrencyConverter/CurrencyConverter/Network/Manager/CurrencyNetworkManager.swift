//
//  CurrencyNetworkManager.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import Combine

protocol CyrrencuNetworkProtocol {
    func getCurrencies() -> AnyPublisher<[CurrencyModel], Error>
    func getExchangeRate(from: String, outOff: [String])
}


final class CurrencyNetworkManager: CyrrencuNetworkProtocol {
    
    func getCurrencies() -> AnyPublisher<[CurrencyModel], Error> {
        let headers = [HTTPConstants.Headers.Keys.contentType: HTTPConstants.Headers.Values.applicationJSON]
        
        let urlString = String(format: APIConstants.currency.rawValue)
        
        let request = NetworkRequest(urlString: urlString,
                                     method: .get,
                                     body: nil,
                                     headers: headers)
        return URLSessionNetworkDispatcher.dispatch(request: request)
    }
    
    func getExchangeRate(from: String, outOff: [String]) {
        fatalError("Not implemented")
    }
    
}
