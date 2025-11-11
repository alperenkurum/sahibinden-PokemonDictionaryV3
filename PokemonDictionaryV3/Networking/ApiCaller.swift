////
////  ApiCaller.swift
////  PokemonDictionaryV2
////
////  Created by Ibrahim Alperen Kurum on 22.10.2025.
////
//
//import Foundation
//
//class ApiCaller {
//    var currentPage: Int = 0 // buradan kaldır
//    let baseApiURL: String = "https://pokeapi.co/api/v2/pokemon"
//    
//    private func getPokemonURLs(limit pageLimit: Int = 20) async throws -> Result <PokemonURL, ApiCallError> {
//        var components = URLComponents(string: baseApiURL)
//        components?.queryItems = [
//            URLQueryItem(name: "limit", value: String(pageLimit)),
//            URLQueryItem(name: "offset", value: String(currentPage*pageLimit))
//        ]
//        guard let url = components?.url else {
//            return .failure(ApiCallError.urlConvertionFailed)
//        }        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            return .failure(ApiCallError.invalidResponse)
//        }
//        do{
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            currentPage+=1
//            return try .success(decoder.decode(PokemonURL.self, from: data))
//        }catch{
//            return .failure(ApiCallError.decodingFailed)
//        }
//    }
//    
//    func getPokemonDatas() async throws -> Result <[Pokemon], ApiCallError> {
//        let result = try await getPokemonURLs(limit: 24)
//        switch result {
//        case .success(let urlList):
//            var pokemonList: [Pokemon] = []
//            
//            try await withThrowingTaskGroup(of: Pokemon?.self) { group in
//                for pokemonUrl in urlList.results {
//                    group.addTask {
//                        let result = try await self.getFrontPokemonData(URL: pokemonUrl.url)
//                        switch result {
//                        case .success(let pokemon):
//                            return pokemon
//                        case .failure(let error):
//                            print("Failed to fetch \(pokemonUrl.name): \(error)")
//                            return nil
//                        }
//                    }
//                }
//                for try await pokemon in group {
//                    if let pokemon = pokemon {
//                        pokemonList.append(pokemon)
//                    }
//                }
//            }
//            
//            return .success(pokemonList)
//        case .failure:
//            return .failure(ApiCallError.invalidResponse)
//        }
//    }
//    
//    func getFrontPokemonData(URL endpoint: String) async throws -> Result<Pokemon, ApiCallError> {
//        guard let url = URL(string: endpoint) else {
//            return .failure(ApiCallError.urlConvertionFailed)
//        }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            return .failure(ApiCallError.invalidResponse)
//        }
//        do{
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            return try .success(decoder.decode(Pokemon.self, from: data))
//        }catch {
//            return .failure(ApiCallError.decodingFailed)
//        }
//    }
//    
//    func getPokemonDetails(ID id: Int) async throws -> Result<PokemonDetail, ApiCallError> {
//        let urlString = "\(baseApiURL)/\(id)"
//        guard let url = URL(string: urlString) else {
//            return .failure(ApiCallError.urlConvertionFailed)
//        }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            return .failure(.invalidResponse)
//        }
//        do{
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            return .success(try decoder.decode(PokemonDetail.self, from: data))
//        } catch {
//            return .failure(.decodingFailed)
//        }
//    }
//}
//
//
//
