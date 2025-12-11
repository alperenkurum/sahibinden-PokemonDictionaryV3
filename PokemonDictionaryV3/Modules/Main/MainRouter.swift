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
    func navigateToDetail(with idList: [Int]) {
        let detailViewController = createDetailViewController(idList: idList)
        view?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func createDetailViewController(idList: [Int]) -> DetailViewController {
        let detailModule = DetailModule()
        let detailViewController = detailModule.build(with: idList)
        return detailViewController
    }
    
    func presentAlert(message: String){
        let alert = UIAlertController(title: "Pokemon Fetching Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel, handler: nil))
        view?.present(alert, animated: true)
    }
}
