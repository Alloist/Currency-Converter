//
//  MainConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import SwiftUI

protocol MainConverterViewModelProtocol {
    var sellCurrency: CurrencyModel? { get }
    var buyCurrency: CurrencyModel? { get }
    var availableСurrencies: [CurrencyModel] { get }
    var isLoading: Bool { get }
    var isShownCurrencyList: Bool { get }
    
    var exchangeType: ExchangeType { get }
    var exchangeRate: String { get }
    
    func showCurrencyList(for: ExchangeType)
    func swapCurrencies()
}

final class MainConverterViewModel: MainConverterViewModelProtocol, ObservableObject {
    
    private var useCase: MainConverterUseCaseProtocol
    private var isLoaded: Bool = false
    
    var exchangeType: ExchangeType = .sell
    
    @Published var sellCurrency: CurrencyModel?
    @Published var buyCurrency: CurrencyModel?
    
    @Published var error: Error?
    @Published var isLoading: Bool = true
    @Published var isShownCurrencyList: Bool = false
    
    @Published var exchangeRate: String = ""
    
    var availableСurrencies: [CurrencyModel] {
        get {
            var selectedID: [String] = []
            if let sellCurrency = sellCurrency {
                selectedID.append(sellCurrency.id)
            }
            if let buyCurrency = buyCurrency {
                selectedID.append(buyCurrency.id)
            }
            
            return useCase.allCurrencies.filter{ !selectedID.contains($0.id) }
        }
    }
    
    //MARK: Init
    init(useCase: MainConverterUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func didLoad() {
        self.isLoading = true
        guard !isLoaded else { return }
        
        Task(priority: .userInitiated) {
            do {
                try await self.useCase.getAppData()
            } catch {
                //TODO: Handle Error state
                debugPrint(error.localizedDescription)
            }
            await MainActor.run {
                self.isLoading = false
                self.isShownCurrencyList = true
            }
        }
    }
    
    func showCurrencyList(for type: ExchangeType) {
        exchangeType = type
        isShownCurrencyList = true
    }
    
    func didSelectModel(code: String) {
        isShownCurrencyList = false
        guard let item = useCase.allCurrencies.first(where: { $0.model.code == code })
        else {
            //TODO: Handle Error state
            print(#function, "Cannot find currency with code: \(code)")
            return
        }
        
        switch exchangeType {
        case .sell:
            self.sellCurrency = item
        case .buy:
            self.buyCurrency = item
        }
        
        prepareExchangeRate()
    }
    
    func swapCurrencies() {
        let intermediateModel = sellCurrency
        sellCurrency = buyCurrency
        buyCurrency = intermediateModel
    }
    
}


private extension MainConverterViewModel {
    
    func prepareExchangeRate() {
        guard let sellCurrency = sellCurrency,
        let buyCurrency = buyCurrency,
        let rate = sellCurrency.rate[buyCurrency.model.code] else {
            return
        }
        exchangeRate = "1 \(sellCurrency.model.symbolNative) = \(rate) \(buyCurrency.model.symbolNative)"
    }
}
