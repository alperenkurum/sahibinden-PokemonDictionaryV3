//
//  PokemonURL.swift
//  PokemonDictionaryV2
//
//  Created by Ibrahim Alperen Kurum on 22.10.2025.
//

import Foundation

struct PokemonURL: Decodable {
    var results: [Results]
}
struct Results: Decodable {
    var name: String
    var url: String
}
