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
    private var apiCaller = ApiCaller()
    private var ids: [Int] = []
    var pokemons: [PokemonDetail] = []
    init(with ids: [Int]) {
        self.ids = ids
    }
}

// MARK: - Introduction Presenter to Interactor
extension DetailInteractor: DetailPresenterToInteractor {
    func fetchPokemonData() async {
        if ids.count > 1 {
            for id in ids {
                await apiCall(ID: id)
            }
        }else{
            await apiCall(ID: ids[0])
        }
    }
    
    func getIdListCount() -> Int {
        return ids.count
    }
    
    private func apiCall(ID id: Int) async{
        do{
            let result = try await apiCaller.getPokemonDetails(ID: id)
            switch result {
            case .success(let pokemon):
                pokemons.append(pokemon)
            case .failure(let error):
                print(error)
            }
        }catch {
            print(error)
        }
    }
}
