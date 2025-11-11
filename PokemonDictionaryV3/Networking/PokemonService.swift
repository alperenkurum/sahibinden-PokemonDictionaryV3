//
//  PokemonService.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 6.11.2025.
//

import Foundation

final class PokemonService {
    private let network = NetworkManager.shared
    
    func fetchPokemonList(limit: Int = 24, offset: Int = 0) async throws -> PokemonURL {
        let data = try await network.request(.pokemonList(limit: limit, offset: offset), type: PokemonURL.self)
        return data
    }
    
    func fetchPokemon(_ urlString: String) async throws -> Pokemon {
        return try await network.request(.custom(url: urlString), type: Pokemon.self)
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        return try await network.request(.pokemonDetail(id: id), type: PokemonDetail.self)
    }
    
    /// Fetch multiple Pokémon concurrently
    func fetchPokemonBatch(limit: Int = 24, offset: Int = 0) async throws -> [Pokemon] {
        let urlList = try await fetchPokemonList(limit: limit, offset: offset)
        
        return try await withThrowingTaskGroup(of: Pokemon?.self) { group in
            for item in urlList.results {
                group.addTask {
                    do {
                        return try await self.fetchPokemon(item.url)
                    } catch {
                        print("Failed to fetch \(item.name): \(error)")
                        return nil
                    }
                }
            }
            
            var pokemons: [Pokemon] = []
            for try await pokemon in group {
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                }
            }
            return pokemons
        }
    }
}

