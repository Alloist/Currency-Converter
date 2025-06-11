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
    var saleCurrency: CurrencyModel? { get }
    var buyCurrency: CurrencyModel? { get }
    var allCurrency: [CurrencyModel] { get }
    
    func didLoad()
    func getAllCurrencyList()
    func selectSaleCurrency(_ currency: CurrencyModel)
    func selectBuyCurrency(_ currency: CurrencyModel)
    func swapCurrencies()
}


final class MainConverterViewModel: MainConverterViewModelProtocol, ObservableObject {
    
    @Published var saleCurrency: CurrencyModel?
    @Published var buyCurrency: CurrencyModel?
    @Published var allCurrency: [CurrencyModel] = []
    
    private var isLoading: Bool = false
    
    init() {
        
    }
    
    func didLoad() {
        guard isLoading else { return }
        self.saleCurrency = rubModel()
        self.buyCurrency = usdModel()
    }
    
    func getAllCurrencyList() {
        
    }
    
    func selectSaleCurrency(_ currency: CurrencyModel) {
        
    }
    
    func selectBuyCurrency(_ currency: CurrencyModel) {
        
    }
    
    func swapCurrencies() {
        let intermediateModel = saleCurrency
        saleCurrency = buyCurrency
        buyCurrency = intermediateModel
        debugPrint(#function)
    }
    
}

private extension MainConverterViewModel {
    func usdModel() -> CurrencyModel {
        .init(symbol: "$",
              name: "US Dollar",
              symbolNative: "$",
              decimalDigits: 2,
              rounding: 0,
              code: "USD",
              namePlural: "US dollars",
              type: "fiat")
    }
    
    func rubModel() -> CurrencyModel {
        .init(symbol: "RUB",
              name: "Russian Ruble",
              symbolNative: "руб.",
              decimalDigits: 2,
              rounding: 0,
              code: "RUB",
              namePlural: "Russian ruble",
              type: "fiat")
    }
}
