//
//  Pokemon.swift
//  PokemonDictionaryV2
//
//  Created by Ibrahim Alperen Kurum on 22.10.2025.
//

import Foundation

struct Pokemon: Decodable {
    var name: String
    var id: Int
    var sprites: Sprites
}
struct Sprites: Decodable {
    var frontDefault: String
    var backDefault: String
}
