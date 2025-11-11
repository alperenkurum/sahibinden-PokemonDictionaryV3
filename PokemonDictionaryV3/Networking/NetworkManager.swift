//
//  NetworkService.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 6.11.2025.
//

import Foundation

enum ApiCallError: Error {
    case urlConvertionFailed
    case invalidResponse
    case decodingFailed
    case imageDecodingFailed
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        type: T.Type
    ) async throws -> T {
        guard let url = endpoint.url else {
            throw ApiCallError.urlConvertionFailed
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ApiCallError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ApiCallError.decodingFailed
        }
    }
}
