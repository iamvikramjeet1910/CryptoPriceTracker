//
//  CryptoPrice.swift
//  Crypto Price Tracker
//
//  Created by Vikram Kumar on 12/06/25.
//

import SwiftUI

struct CryptoPrice: Codable, Identifiable {
    let id : String
    let symbol : String
    let name : String
    let current_price : Double
    let image : String
}
