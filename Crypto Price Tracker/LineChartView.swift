//
//  LineChartView.swift
//  Crypto Price Tracker
//
//  Created by Vikram Kumar on 12/06/25.
//
import Charts
import SwiftUI

struct LineChartView: View {
    let prices: [Double]

    var body: some View {
        Chart {
            ForEach(prices.indices, id: \.self) { idx in
                LineMark(
                    x: .value("Day", idx),
                    y: .value("Price", prices[idx])
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            }
        }
        .frame(height: 200)
        .animation(.easeInOut, value: prices)
    }
}
