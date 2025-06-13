//
//  MainConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import SwiftUI
import Combine

protocol MainConverterViewModelProtocol {
    var sellCurrency: CurrencyModel? { get }
    var buyCurrency: CurrencyModel? { get }
    var availableСurrencies: [CurrencyModel] { get }
    var isLoading: Bool { get }
    var isShownCurrencyList: Bool { get }
    var sellAmount: Double? { get }
    var buyAmount: Double? { get }
    var exchangeType: ExchangeType { get }
    var exchangeRate: String { get }
    
    func didLoad()
    func showCurrencyList(for: ExchangeType)
    func didSelectModel(code: String)
    func swapCurrencies()
}

final class MainConverterViewModel: MainConverterViewModelProtocol, ObservableObject {
    
    private var useCase: MainConverterUseCaseProtocol
    private var isLoaded: Bool = false
    
    private var cancelBag: Set<AnyCancellable> = []
    
    var exchangeType: ExchangeType = .sell
    
    @Published var sellCurrency: CurrencyModel?
    @Published var buyCurrency: CurrencyModel?
    @Published var sellAmount: Double?
    @Published var buyAmount: Double?
    
    private var debouncedSellAmount: Double?
    private var debouncedBuyAmount: Double?
    
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
        setupDebounce()
    }
    
    private func setupDebounce() {
        debouncedSellAmount = sellAmount
        debouncedBuyAmount = buyAmount
        
        $sellAmount
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink{ [weak self] value in
                if value != self?.debouncedSellAmount {
                    let calculation = self?.calcualteAmount(type: .sell)
                    
                    self?.buyAmount = calculation
                    self?.debouncedBuyAmount = calculation
                    return
                }
                self?.sellAmount = value
            }
            .store(in: &cancelBag)
        
        $buyAmount
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink {[weak self] value in
                if value != self?.debouncedBuyAmount {
                    let calculation = self?.calcualteAmount(type: .buy)
                    self?.sellAmount = calculation
                    self?.debouncedSellAmount = calculation
                    return
                }
                self?.buyAmount = value
            }
            .store(in: &cancelBag)
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
        let value = buyAmount
        sellAmount = value
        prepareExchangeRate()
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
    
    func calcualteAmount(type: ExchangeType) -> Double? {
        switch type {
        case .buy:
            guard let amount = buyAmount,
                  let sellCurrency = sellCurrency,
                  let buyCurrency = buyCurrency,
                  let rate = buyCurrency.rate[sellCurrency.model.code] else {
                return nil
            }
            
            return (amount / rate)
            
        case .sell:
            guard let amount = sellAmount,
                  let sellCurrency = sellCurrency,
                  let buyCurrency = buyCurrency,
                  let rate = sellCurrency.rate[buyCurrency.model.code] else {
                return nil
            }
            
            return (amount * rate)
        }
        
        //TODO: save exchange pair to history
    }
    
}
