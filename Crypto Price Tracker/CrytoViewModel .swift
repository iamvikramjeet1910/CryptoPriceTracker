//
//  CrytoViewModel .swift
//  Crypto Price Tracker
//
//  Created by Vikram Kumar on 12/06/25.
//

import Foundation

@MainActor
class CryptoViewModel: ObservableObject {
    @Published var prices: [CryptoPrice] = []
    @Published var history: [Double] = []

    func fetchPrices() async {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode([CryptoPrice].self, from: data)
            prices = response
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
    
    func fetchHistory(for coinID: String) async {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinID)/market_chart?vs_currency=usd&days=7"
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MarketChartResponse.self, from: data)
            history = response.prices.map { $0[1] }
        } catch {
            print("Error: \(error)")
            history = []
        }
    }
}
