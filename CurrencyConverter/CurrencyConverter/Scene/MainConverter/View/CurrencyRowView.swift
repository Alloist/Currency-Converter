//
//  CurrencyRowView.swift
//  CurrencyConverter
//
//  Created by Aliaksei Gorodji on 12.06.25.
//

import SwiftUI

struct CurrencyRowView: View {
    
    @State var code: String
    @State var symbol: String
    @State var name: String
    private var completion: (String) -> Void
    
    init(code: String, symbol: String, name: String, completion: @escaping (String) -> Void) {
        self.code = code
        self.symbol = symbol
        self.name = name
        self.completion = completion
    }
    
      var body: some View {
          Button {
              completion(code)
          } label: {
              ZStack(alignment: .leading){
                  HStack(){
                      Text(name)
                          .foregroundStyle(.black)
                          .font(.title3)
                      Text("(\(code))")
                          .foregroundStyle(.black)
                          .font(.title3)
                      Spacer()
                      Text(symbol)
                          .foregroundStyle(.black)
                          .font(.title3)
                  }
                  .padding()
              }
          }
      }
}
