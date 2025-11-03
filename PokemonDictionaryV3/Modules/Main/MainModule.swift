//
//  MainInteractor.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import UIKit

final class MainModule {
    func build() -> MainViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let router = MainRouter()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.view = view

        return view
    }
}
