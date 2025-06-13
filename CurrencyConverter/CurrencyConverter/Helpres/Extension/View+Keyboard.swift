//
//  View+Keyboard.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 13.06.25.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    
    /// [Hackingwithswift](https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
#endif
