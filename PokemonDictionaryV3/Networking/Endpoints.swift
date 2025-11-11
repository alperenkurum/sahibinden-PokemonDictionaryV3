//
//  Endpoints.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 6.11.2025.
//

import Foundation

enum Endpoint {
    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(id: Int)
    case custom(url: String)
    
    private var baseURL: String { "https://pokeapi.co/api/v2/pokemon" }
    
    var url: URL? {
        switch self {
        case .pokemonList(let limit, let offset):
            var components = URLComponents(string: baseURL)
            components?.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            return components?.url
            
        case .pokemonDetail(let id):
            return URL(string: "\(baseURL)/\(id)")
            
        case .custom(let urlString):
            return URL(string: urlString)
        }
    }
}

