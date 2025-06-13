//
//  MainConverterUseCase.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation
import Combine


protocol MainConverterUseCaseProtocol {
    var allCurrencies: [CurrencyModel] { get }
    
    func getAppData() async throws
}

final class MainConverterUseCase: MainConverterUseCaseProtocol, ObservableObject {
    
    private let networkManager: CyrrencuNetworkProtocol
    
    var allCurrencies: [CurrencyModel] = []
    private var responseCurrencies: [CurrencyResponseModel] = []
    
    private var cancelBag: Set<AnyCancellable> = []
    
    
    init(networkManager: CyrrencuNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func getAppData() async throws {
        do {
            let currencyData = try await networkManager.getCurrencies()
            let items = currencyData.data.compactMap({ (key: String, value: CurrencyResponseModel) in
                return value
            })
            self.responseCurrencies = items
            
            let currenciesArr = try await responseCurrencies.asyncMap { model in
                let responseData = try await networkManager.getExchangeRate(from: model.code)
                return CurrencyModel(model: model, rate: responseData.data)
            }
            self.allCurrencies = currenciesArr.sorted { $0.model.name < $1.model.name }
        } catch {
            throw error
        }
    }
    
    func getCurrencyRate() async throws {
        responseCurrencies.forEach { [weak self] model in
            Task(priority: .userInitiated) {
                do {
                    if let responseData = try await self?.networkManager.getExchangeRate(from: model.code) {
                        self?.allCurrencies.append(CurrencyModel(model: model, rate: responseData.data))
                    }
                } catch {
                    debugPrint("Error: \(error), fetch model rate:\(model.code)")
                    throw error
                }
            }
        }
    }
}
