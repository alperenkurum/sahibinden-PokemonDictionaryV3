//
//  MainInteractor.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import Foundation

// MARK: - Main Interactor
final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainInteractorToPresenter?
    //presenter
    //var selectedIdList: [Int] = []
    private var apiCaller = ApiCaller()
    
}

// MARK: - Introduction Presenter to Interactor
extension MainInteractor: MainPresenterToInteractor {
    func fetchPokemons() {
        Task{
            do{
                let result = try await apiCaller.getPokemonURLs(Limit: 24)
                switch result {
                case .success(let pokemonResult):
                    let resultPoke = try await apiCaller.getPokemonDatas(URLs: pokemonResult)
                    switch resultPoke {
                    case .success(let pokemonResult):
                        self.presenter?.fetchPokemonsDidSuccess(pokemons: pokemonResult)
                    case .failure(let error):
                        self.presenter?.fetchPokemonsDidFail(message: error.localizedDescription)
                    }
                case .failure(let error):
                    print(error)
                }
                
            }catch{
                fatalError("blap")
            }
        }
    }
}
