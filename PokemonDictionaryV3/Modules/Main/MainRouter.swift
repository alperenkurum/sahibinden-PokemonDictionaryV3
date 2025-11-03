//
//  MainRouter.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import UIKit

//MARK: -Main Router
final class MainRouter: MainRouterProtocol {
    weak var presenter: (any MainRouterToPresenter)?
    weak var view: (UIViewController & MainView)?
    
}

extension MainRouter: MainPresenterToRouter {
    
}
