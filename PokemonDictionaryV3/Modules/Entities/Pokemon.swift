//
//  Pokemon.swift
//  PokemonDictionaryV2
//
//  Created by Ibrahim Alperen Kurum on 22.10.2025.
//

import Foundation

struct Pokemon: Decodable, Hashable {
    var name: String
    var id: Int
    var sprites: Sprites
}
struct Sprites: Decodable, Hashable {
    var frontDefault: String
    var backDefault: String
}

enum Section{
    case main
}
