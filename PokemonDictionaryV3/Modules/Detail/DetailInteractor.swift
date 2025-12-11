//
//  DetailInteractor.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import Foundation

// MARK: - Introduction Interactor
final class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailInteractorToPresenter?
    private var service = PokemonService()
    private var ids: [Int] = []
    var pokemons: [PokemonDetail] = []
    init(with ids: [Int]) {
        self.ids = ids
    }
}

// MARK: - Introduction Presenter to Interactor
extension DetailInteractor: DetailPresenterToInteractor {
    func fetchPokemonData() async {
        for id in ids {
            await apiCall(ID: id)
        }
    }
    
    func getIdListCount() -> Int {
        ids.count
    }
    
    private func apiCall(ID id: Int) async{
        do{
            let pokemonDetail = try await service.fetchPokemonDetail(id: id)
            pokemons.append(pokemonDetail)
        }catch {
            print(error)
        }
    }
}
