//
//  MainPresenter.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import UIKit

// MARK: - Introduction Presenter
final class MainPresenter: MainPresenterProtocol {
    weak var view: MainPresenterToView?
    var interactor: MainPresenterToInteractor
    var router: MainPresenterToRouter
    private var pokemons: [Pokemon] = []
    var selectedIdList: [Int] = []

    // MARK: - Initialization
    init(view: MainPresenterToView, interactor: MainPresenterToInteractor, router: MainPresenterToRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Introduction View to Presenter
extension MainPresenter: MainViewToPresenter {
    func getPokemon(index: Int) -> Pokemon {
        return pokemons[index]
    }
    
    func onLoad() {
        view?.toggleLoading()
        interactor.fetchPokemons()
    }
    
    func loadMorePokemons() -> [IndexPath]{
        view?.toggleLoading()
        let startIndex = pokemons.count
        interactor.fetchPokemons()
        let endIndex = pokemons.count
        let newIndexPaths = (startIndex..<endIndex).map {IndexPath(item: $0, section: 0)}
        
        return newIndexPaths
    }
    
    func getSelectedIdListCount() -> Int {
        return selectedIdList.count
    }
    
    func removeAllSelectedIdList() {
        selectedIdList.removeAll()
    }
    
    func getPokemonCount() -> Int {
        pokemons.count
    }
}

// MARK: - Introduction Interactor to Presenter
extension MainPresenter: MainInteractorToPresenter {
    func fetchPokemonsDidSuccess(pokemons: [Pokemon]){
        self.pokemons.append(contentsOf: pokemons)
        view?.reloadPokemonData()
        view?.toggleLoading()
    }
    
    func fetchPokemonsDidFail(message: String){
        print(message)
    }
}

// MARK: - Introduction Router to Presenter
extension MainPresenter: MainRouterToPresenter {
    
}
