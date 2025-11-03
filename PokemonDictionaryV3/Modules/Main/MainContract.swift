//
//  MainContract.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import UIKit

protocol MainViewToPresenter: AnyObject {
    func onLoad()
    func getSelectedIdListCount() -> Int
    func removeAllSelectedIdList()
    func getPokemonCount() -> Int
    func getPokemon(index: Int) -> Pokemon
    func loadMorePokemons() -> [IndexPath]
    var selectedIdList: [Int] {get set}
}

protocol MainPresenterToView: AnyObject {
    func toggleLoading()
    func reloadPokemonData()
}

protocol MainInteractorToPresenter: AnyObject {
    func fetchPokemonsDidSuccess(pokemons: [Pokemon])
    func fetchPokemonsDidFail(message: String)
}

protocol MainPresenterToInteractor: AnyObject {
    func fetchPokemons()
}

protocol MainPresenterToRouter: AnyObject{
}

protocol MainRouterToPresenter: AnyObject{
}

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainInteractorToPresenter? { get set }
}

protocol MainPresenterProtocol: AnyObject {
    var view: MainPresenterToView? { get set }
    var interactor: MainPresenterToInteractor { get set }
    var router: MainPresenterToRouter { get set }
}

protocol MainRouterProtocol: AnyObject {
    var presenter: MainRouterToPresenter? { get set }
}

protocol MainView: AnyObject {
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: MainViewToPresenter! { get set }
    // swiftlint:enable implicitly_unwrapped_optional
}
