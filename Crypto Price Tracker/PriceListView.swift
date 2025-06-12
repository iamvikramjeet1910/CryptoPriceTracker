//
//  PriceListView.swift
//  Crypto Price Tracker
//
//  Created by Vikram Kumar on 12/06/25.
//

import SwiftUI

struct PriceListView : View {
    @StateObject var viewModel = CryptoViewModel()
    
    var body: some View {
        NavigationView{
            List(viewModel.prices) { coin in
                HStack {
                    Text(coin.name)
                    Spacer()
                    Text(String(format: "%.2f", coin.current_price))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: coin.current_price)
                }
            }
            .navigationTitle("Crypto Prices")
            .refreshable {
                await viewModel.fetchPrices()
            }
            .task {
                await viewModel.fetchPrices()
            }
        }
    }
}
