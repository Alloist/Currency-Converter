//
//  MainConverterView.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import SwiftUI

struct MainConverterView: View {
    
    @StateObject private var viewModel = MainConverterViewModel()
    
    @State private var saleCurrencyValue: Double? = nil
    @State private var buyCurrencyValue: Double? = nil
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    Image("Logo")
                        .onAppear {
                            viewModel.didLoad()
                        }
                    //Sale
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Spacer()
                            Text(viewModel.saleCurrency?.name ?? "")
                                .font(.system(size: 16))
                                .padding(.trailing)
                        }
                        
                        HStack(spacing: 4) {
                            Text(viewModel.saleCurrency?.code ?? "")
                                .font(.system(size: 20))
                                .padding(.leading)
                            CCTextField(model: TextFieldCurrencyModel(placeholder: "Your sale",
                                                                      value: $saleCurrencyValue,
                                                                      systemImageName: AppSystemImages.saleIcon.rawValue,
                                                                      currencySymbol: viewModel.saleCurrency?.symbolNative ?? "",
                                                                      currencyCode: viewModel.saleCurrency?.code ?? "")
                            )
                            .padding(.leading, -8)
                        }
                    }
                    .padding(.top, -32)
                    
                    //Swap
                    HStack(alignment: .center) {
                        Button(action: {
                            viewModel.swapCurrencies()
                            debugPrint("swap currency")
                        }) {
                            Image(systemName: AppSystemImages.swapIcon.rawValue)
                                .resizable()
                                .tint(Color.cyan)
                        }
                        .frame(width: 44, height: 44)
                        .padding(.leading, 16)
                        .padding(.top, -16)
                        .padding(.bottom, -16)
                        
                        Spacer()
                        Text("1 USD = 3.60 AED")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    
                    //Buy
                    VStack(spacing: 0) {
                        HStack(spacing: 4) {
                            Text(viewModel.buyCurrency?.code ?? "")
                                .font(.system(size: 20))
                                .padding(.leading)
                            
                            CCTextField(model: TextFieldCurrencyModel(placeholder: "Your recieve",
                                                                      value: $buyCurrencyValue,
                                                                      systemImageName: AppSystemImages.buyIcon.rawValue,
                                                                      currencySymbol: viewModel.buyCurrency?.symbolNative ?? "",
                                                                      currencyCode: viewModel.buyCurrency?.code ?? "")
                            )
                            .padding(.leading, -8)
                        }
                        
                        HStack(spacing: 0) {
                            Spacer()
                            Text(viewModel.buyCurrency?.namePlural ?? "")
                                .font(.system(size: 16))
                                .padding(.trailing)
                        }
                    }
                    
                    Spacer()
                    Text("Current rate as of 13:22 | 24.06.2025")
                }
            }
        }
    }
}

#Preview {
    MainConverterView()
}
