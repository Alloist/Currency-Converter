//
//  MainConverterView.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import SwiftUI
import Combine

struct MainConverterView: View {
    
    @StateObject private var viewModel: MainConverterViewModel
    
    @State private var debounceCancellable: AnyCancellable?
    
    init(viewModel: MainConverterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if viewModel.isLoading == true {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                            .scaleEffect(2)
                    }
                } else {
                    VStack(spacing: 8) {
                        Image("Logo")
                            .onTapGesture {
                                hideKeyboard()
                            }
                        //Sell
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Spacer()
                                Text(viewModel.sellCurrency?.model.name ?? "")
                                    .font(.system(size: 16))
                                    .padding(.trailing)
                            }
                            
                            HStack(spacing: 4) {
                                Button {
                                    viewModel.showCurrencyList(for: .sell)
                                } label: {
                                    if viewModel.sellCurrency == nil {
                                        Image(systemName: AppSystemImages.addCurrencyIcon.rawValue)
                                            .resizable()
                                            .tint(.cyan)
                                            .frame(width: 32, height: 32)
                                    }
                                    Text(viewModel.sellCurrency?.model.code ?? "")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 20))
                                }
                                .padding(.leading)
                                .frame(minWidth: 50)
                                
                                CCTextField(model: TextFieldCurrencyModel(placeholder: "Your sell",
                                                                          value: $viewModel.sellAmount,
                                                                          systemImageName: AppSystemImages.sellIcon.rawValue,
                                                                          currencySymbol: viewModel.sellCurrency?.model.symbolNative ?? "",
                                                                          currencyCode: viewModel.sellCurrency?.model.code ?? ""))
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                                .padding(.leading, -8)
                            }
                        }
                        .padding(.top, -32)
                        
                        //Swap
                        HStack(alignment: .center) {
                            Button(action: {
                                viewModel.swapCurrencies()
                            }) {
                                if viewModel.sellCurrency != nil && viewModel.buyCurrency != nil {
                                    Image(systemName: AppSystemImages.swapIcon.rawValue)
                                        .resizable()
                                        .tint(Color.cyan)
                                }
                            }
                            .frame(width: 44, height: 44)
                            .padding(.leading, 16)
                            .padding(.top, -16)
                            .padding(.bottom, -16)
                            
                            Spacer()
                            Text(viewModel.exchangeRate)
                                .font(.system(size: 20, weight: .semibold))
                            Spacer()
                        }
                        
                        //Buy
                        VStack(spacing: 0) {
                            HStack(spacing: 4) {
                                Button {
                                    viewModel.showCurrencyList(for: .buy)
                                } label: {
                                    if viewModel.buyCurrency == nil {
                                        Image(systemName: AppSystemImages.addCurrencyIcon.rawValue)
                                            .resizable()
                                            .tint(.cyan)
                                            .frame(width: 32, height: 32)
                                    }
                                    Text(viewModel.buyCurrency?.model.code ?? "")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 20))
                                }
                                .padding(.leading)
                                .frame(minWidth: 50)
                                
                                CCTextField(model: TextFieldCurrencyModel(placeholder: "Your recieve",
                                                                          value: $viewModel.buyAmount,
                                                                          systemImageName: AppSystemImages.buyIcon.rawValue,
                                                                          currencySymbol: viewModel.buyCurrency?.model.symbolNative ?? "",
                                                                          currencyCode: viewModel.buyCurrency?.model.code ?? ""))
                                .padding(.leading, -8)
                            }
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Text(viewModel.buyCurrency?.model.namePlural ?? "")
                                    .font(.system(size: 16))
                                    .padding(.trailing)
                            }
                        }
                        
                        Spacer()
                        //TODO: Set the correct date
                        Text("Current rate as of 13:22 | 24.06.2025")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShownCurrencyList) {
                List(viewModel.availableСurrencies, id: \.self,) {
                    CurrencyRowView(code: $0.model.code,
                                    symbol: $0.model.symbolNative,
                                    name: $0.model.name) { code in
                        viewModel.didSelectModel(code: code)
                    }
                }
            }
        }
        .onAppear {
            viewModel.didLoad()
        }
    }
}

#Preview {
    MainConverterView(
        viewModel: MainConverterViewModel(useCase: MainConverterUseCase(networkManager: CurrencyNetworkManager()))
    )
}
