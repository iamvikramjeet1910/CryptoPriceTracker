//
//  ContentView.swift
//  Crypto Price Tracker
//
//  Created by Vikram Kumar on 12/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CryptoViewModel()
    @State private var selectedCoin: CryptoPrice? = nil
    @State private var showDetail = false

    var body: some View {
        NavigationView {
            List(vm.prices) { coin in
                Button {
                    selectedCoin = coin
                    showDetail = true
                    Task { await vm.fetchHistory(for: coin.id) }
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: coin.image)) { image in
                            image.resizable().clipShape(Circle())
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 32, height: 32)
                        
                        VStack(alignment: .leading) {
                            Text(coin.name)
                            Text(coin.symbol.uppercased()).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(String(format: "$%.2f", coin.current_price))
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Crypto Prices")
            .refreshable {
                await vm.fetchPrices()
            }
            .task {
                await vm.fetchPrices()
            }
            .sheet(isPresented: $showDetail) {
                if let coin = selectedCoin {
                    CryptoDetailView(coin: coin, prices: vm.history)
                }
            }
        }
    }
}

struct CryptoDetailView: View {
    let coin: CryptoPrice
    let prices: [Double]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: coin.image)) { image in
                    image.resizable().clipShape(Circle())
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 72, height: 72)

                Text(coin.name)
                    .font(.title)
                
                Text(String(format: "$%.2f", coin.current_price))
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
                
                if !prices.isEmpty {
                    LineChartView(prices: prices)
                        .padding(.top)
                } else {
                    ProgressView()
                        .padding(.top)
                }
            }
            .padding()
        }
    }
}
