//
//  CurrencyTextField.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 11.06.25.
//

import SwiftUI

struct TextFieldCurrencyModel {
    var placeholder: String
    var value: Binding<Double?>
    var systemImageName: String
    var currencySymbol: String
    var decimalDigits: Int?
    var currencyCode: String
}

struct CCTextField: View {
    
    private let model: TextFieldCurrencyModel
    
    init(model: TextFieldCurrencyModel, keyboardType: UIKeyboardType = .default) {
        self.model = model
    }
    
    var body: some View {
        createCurrencyTextField()
    }
    
    private func createCurrencyTextField() -> some View {

        TextField(model.placeholder, value: model.value,
                  format: .number.precision(.fractionLength(2)))
            .submitLabel(.next)
            .keyboardType(.decimalPad)
            .autocorrectionDisabled(true)
            .frame(height: 40)
            .safeAreaInset(edge: .leading) {
                Image(systemName: model.systemImageName)
            }
            .safeAreaInset(edge: .trailing, content: {
                Text(model.currencySymbol)
            })
            .padding(.all)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
            .padding([.leading, .trailing], 16)
    }
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = model.currencyCode
        formatter.currencySymbol = model.currencySymbol
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = model.decimalDigits ?? 2
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter
    }
    
}
 

