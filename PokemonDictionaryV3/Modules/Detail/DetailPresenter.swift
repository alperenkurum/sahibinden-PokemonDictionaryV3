//
//  DetailPresenter.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import Foundation

// MARK: - Detail Presenter
final class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailPresenterToView?
    var interactor: DetailPresenterToInteractor
    var router: DetailPresenterToRouter
    private var apiCaller = ApiCaller()

    // MARK: - Initialization
    init(view: DetailPresenterToView, interactor: DetailPresenterToInteractor, router: DetailPresenterToRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Detail View to Presenter
extension DetailPresenter: DetailViewToPresenter {
    func onLoad() {
        Task{
            await interactor.fetchPokemonData()
            DispatchQueue.main.async {
                if self.interactor.getIdListCount() > 1 {
                    self.view?.setMultipleCardsView(pokemonList: self.interactor.pokemons)
                } else {
                    self.view?.setSingleCardView(pokemon: self.interactor.pokemons[0])
                }
            }
        }
    }
}

// MARK: - Detail Interactor to Presenter
extension DetailPresenter: DetailInteractorToPresenter {
}

// MARK: - Detail Router to Presenter
extension DetailPresenter: DetailRouterToPresenter {
    
}
