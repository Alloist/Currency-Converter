//
//  MainConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import Foundation
import Combine
import SwiftUI

protocol MainConverterViewModelProtocol {
    var sellCurrency: CurrencyResponseModel? { get }
    var buyCurrency: CurrencyResponseModel? { get }
    var availableСurrencies: [CurrencyResponseModel] { get }
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
    
    @Published var sellCurrency: CurrencyResponseModel?
    @Published var buyCurrency: CurrencyResponseModel?
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isShownCurrencyList: Bool = false
    
    @Published var exchangeRate: String = ""
        
    private var cancellables = Set<AnyCancellable>()
    
    var availableСurrencies: [CurrencyResponseModel] {
        get {
            var selectedCurrencies: [CurrencyResponseModel] = []
            if let sellCurrency = sellCurrency {
                selectedCurrencies.append(sellCurrency)
            }
            if let buyCurrency = buyCurrency {
                selectedCurrencies.append(buyCurrency)
            }
            return useCase.allCurrency.filter{ !selectedCurrencies.contains($0) }
        }
    }
    
    init(useCase: MainConverterUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func didLoad() {
        guard !isLoaded else { return }
        useCase.getAllCurrencies { [weak self] in
            self?.isLoading = false
            self?.isShownCurrencyList = true
        }
    }
    
    func showCurrencyList(for type: ExchangeType) {
        exchangeType = type
        isShownCurrencyList = true
    }
    
    func didSelectModel(code: String) {
        isShownCurrencyList = false
        guard let item = useCase.allCurrency.first(where: { $0.code == code })
        else {
            print(#function, "Cannot find currency with code: \(code)")
            return
        }
        
        switch exchangeType {
        case .sell:
            self.sellCurrency = item
        case .buy:
            self.buyCurrency = item
            
        }
    }
    
    func swapCurrencies() {
        let intermediateModel = sellCurrency
        sellCurrency = buyCurrency
        buyCurrency = intermediateModel
    }
    
}
