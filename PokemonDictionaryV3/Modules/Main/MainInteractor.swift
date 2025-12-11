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
    private let service = PokemonService()
    private var currentPage = 0
    private var pageLimit = 24
}

// MARK: - Introduction Presenter to Interactor
extension MainInteractor: MainPresenterToInteractor {
    func fetchPokemons() {
        Task{
            do{
                let resultPoke = try await service.fetchPokemonBatch(limit: pageLimit, offset: pageLimit * currentPage)
                currentPage+=1
                self.presenter?.fetchPokemonsDidSuccess(pokemons: resultPoke)
            }catch{
                return
            }
        }
    }
}
