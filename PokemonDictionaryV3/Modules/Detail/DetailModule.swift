//
//  DetailModule.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//
import Foundation

final class DetailModule {
    func build(with ids: [Int]) -> DetailViewController {
        let view = DetailViewController()
        let interactor = DetailInteractor(with: ids)
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.view = view
        return view
    }
}

