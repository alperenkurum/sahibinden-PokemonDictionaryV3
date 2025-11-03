//
//  ApiCaller.swift
//  PokemonDictionaryV2
//
//  Created by Ibrahim Alperen Kurum on 22.10.2025.
//

import Foundation

class ApiCaller{
    var currentPage: Int = 0
    let baseApiURL: String = "https://pokeapi.co/api/v2/pokemon"
    
    func getPokemonURLs(Limit pageLimit: Int = 20) async throws -> Result <PokemonURL, ApiCallError> {
        let endpoint = "\(baseApiURL)?limit=\(pageLimit)&offset=\(currentPage*pageLimit)"
        guard let url = URL(string: endpoint) else {
            return .failure(ApiCallError.urlConvertionFailed)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(ApiCallError.invalidResponse)
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            currentPage+=1
            return try .success(decoder.decode(PokemonURL.self, from: data))
        }catch{
            return .failure(ApiCallError.decodingFailed)
        }
    }
    
    func getPokemonDatas(URLs urlList: PokemonURL) async throws -> Result <[Pokemon], ApiCallError> {
        var pokemonList: [Pokemon] = []
        for pokemonUrl in urlList.results {
            let result = try await getFrontPokemonData(URL: pokemonUrl.url)
                switch result {
                case .success(let pokemon):
                    pokemonList.append(pokemon)
                case .failure(let error):
                    print("Failed to fetch \(pokemonUrl.name): \(error)")
                    continue
                }
        }
        return .success(pokemonList)
    }
    
    func getFrontPokemonData(URL endpoint: String) async throws -> Result<Pokemon, ApiCallError> {
        guard let url = URL(string: endpoint) else {
            return .failure(ApiCallError.urlConvertionFailed)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(ApiCallError.invalidResponse)
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try .success(decoder.decode(Pokemon.self, from: data))
        }catch {
            return .failure(ApiCallError.decodingFailed)
        }
    }
    
    func getPokemonDetails(ID id: Int) async throws -> Result<PokemonDetail, ApiCallError> {
        let urlString = "\(baseApiURL)/\(id)"
        guard let url = URL(string: urlString) else {
            return .failure(ApiCallError.urlConvertionFailed)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(.invalidResponse)
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return .success(try decoder.decode(PokemonDetail.self, from: data))
        } catch {
            return .failure(.decodingFailed)
        }
    }
}

enum ApiCallError: Error {
    case urlConvertionFailed
    case invalidResponse
    case decodingFailed
    case imageDecodingFailed
}


