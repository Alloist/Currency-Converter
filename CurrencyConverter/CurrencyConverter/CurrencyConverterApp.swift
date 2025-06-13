//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            MainConverterView(
                viewModel: MainConverterViewModel(useCase: MainConverterUseCase(networkManager: CurrencyNetworkManager()))
            )
        }
    }
}
