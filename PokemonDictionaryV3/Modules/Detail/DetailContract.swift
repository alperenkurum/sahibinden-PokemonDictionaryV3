//
//  DEt.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//
import UIKit

protocol DetailViewToPresenter: AnyObject {
    func onLoad()
}

protocol DetailPresenterToView: AnyObject {
    func setSingleCardView(pokemon: PokemonDetail)
    func setMultipleCardsView(pokemonList: [PokemonDetail])
}

protocol DetailInteractorToPresenter: AnyObject {
}

protocol DetailPresenterToInteractor: AnyObject {
    func fetchPokemonData() async
    func getIdListCount() -> Int
    var pokemons: [PokemonDetail] {get set}
}

protocol DetailPresenterToRouter: AnyObject{
}

protocol DetailRouterToPresenter: AnyObject{
}

protocol DetailInteractorProtocol: AnyObject {
    var presenter: DetailInteractorToPresenter? { get set }
}

protocol DetailPresenterProtocol: AnyObject {
    var view: DetailPresenterToView? { get set }
    var interactor: DetailPresenterToInteractor { get set }
    var router: DetailPresenterToRouter { get set }
}

protocol DetailRouterProtocol: AnyObject {
    var presenter: DetailRouterToPresenter? { get set }
}

protocol DetailView: AnyObject {
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: DetailViewToPresenter! { get set }
    // swiftlint:enable implicitly_unwrapped_optional
}
