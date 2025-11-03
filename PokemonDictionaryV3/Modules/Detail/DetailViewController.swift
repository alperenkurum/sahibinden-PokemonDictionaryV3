//
//  DetailViewController.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 31.10.2025.
//

import UIKit

// MARK: - Detail ViewController
final class DetailViewController: UIViewController, DetailView {
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: DetailViewToPresenter!
    // swiftlint:enable implicitly_unwrapped_optional
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var pokemonCardView1: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pokemonCardView2: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pokemonCardView3: PokemonCardView = {
        let view = PokemonCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.onLoad()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureScrollView()
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        stackView.addArrangedSubview(pokemonCardView1)
        stackView.addArrangedSubview(pokemonCardView2)
        stackView.addArrangedSubview(pokemonCardView3)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - Detail Presenter to View
extension DetailViewController: DetailPresenterToView {
    func setSingleCardView(pokemon: PokemonDetail) {
        pokemonCardView2.isHidden = true
        pokemonCardView3.isHidden = true
        pokemonCardView1.configure(with: pokemon)
}
    
    func setMultipleCardsView(pokemonList: [PokemonDetail]) {
        pokemonCardView1.configure(with: pokemonList[0])
        pokemonCardView2.configure(with: pokemonList[1])
        pokemonCardView3.configure(with: pokemonList[2])
    }
}
