//
//  MainConverterUseCase.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import Foundation
import Combine


protocol MainConverterUseCaseProtocol {
    var allCurrency: [CurrencyResponseModel] { get }
    func getAllCurrencies(completionHandler: @escaping () -> Void)
}

final class MainConverterUseCase: MainConverterUseCaseProtocol, ObservableObject {
    
    private let networkManager: CyrrencuNetworkProtocol
    
    var allCurrency: [CurrencyResponseModel] = []
    
    private var cancelBag: Set<AnyCancellable> = []
    
    
    init(networkManager: CyrrencuNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func getAllCurrencies(completionHandler: @escaping () -> Void) {
        networkManager.getCurrencies()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                completionHandler()
                switch completion {
                case .failure(let error):
                    debugPrint(error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                let items = response.data.compactMap({ (key: String, value: CurrencyResponseModel) in
                    return value
                })
                self.allCurrency = items
                completionHandler()
            })
            .store(in: &cancelBag)
    }
}
