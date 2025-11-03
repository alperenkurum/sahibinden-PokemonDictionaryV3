//
//  DetailRouter.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import UIKit

// MARK: - Detail Router
final class DetailRouter: DetailRouterProtocol {
    weak var presenter: DetailRouterToPresenter?
    weak var view: (UIViewController & DetailView)?
}

// MARK: - Detail Presenter to Router
extension DetailRouter: DetailPresenterToRouter {

}
