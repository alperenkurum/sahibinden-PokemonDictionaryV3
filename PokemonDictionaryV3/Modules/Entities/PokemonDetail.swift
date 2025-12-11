//
//  PokemonDetail.swift
//  PokemonDictionaryV2
//
//  Created by Ibrahim Alperen Kurum on 22.10.2025.
//

import Foundation

struct PokemonDetail: Decodable, Hashable{
    var id: Int
    var name: String
    var sprites: Sprites
    var weight: Int
    var height: Int
    var abilities: [Ability]
}

struct Ability: Decodable, Hashable{
    var ability: AbilityDetail
    var isHidden: Bool
}

struct AbilityDetail: Decodable, Hashable{
    var name: String
}
