//
//  PokemonCardView.swift
//  PokemonDictionaryV1
//
//  Created by Ibrahim Alperen Kurum on 21.10.2025.
//

import UIKit

class PokemonCardView: UIView {
    private let frontPokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let propertiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backPokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemMint
        label.layer.cornerRadius = 12
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeWeightLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeHeightLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeHiddenAbilityLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokeAbilityLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .left
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 5, left: 5, bottom:5, right: 5)
        label.backgroundColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(outerStackView)
        outerStackView.addArrangedSubview(imageStackView)
        imageStackView.addArrangedSubview(frontPokeImageView)
        imageStackView.addArrangedSubview(backPokeImageView)
        outerStackView.addArrangedSubview(pokeNameLabel)
        outerStackView.addArrangedSubview(propertiesStackView)
        propertiesStackView.addArrangedSubview(pokeHeightLabel)
        propertiesStackView.addArrangedSubview(pokeWeightLabel)
        outerStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(pokeAbilityLabel)
        labelsStackView.addArrangedSubview(pokeHiddenAbilityLabel)
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            pokeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pokeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            propertiesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            propertiesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
    }
    
    func configure(with pokemon: PokemonDetail) {
        frontPokeImageView.load(with: pokemon.sprites.frontDefault)
        backPokeImageView.load(with: pokemon.sprites.backDefault)
        pokeNameLabel.text = pokemon.name.capitalizingFirstLetter()
        pokeHeightLabel.text = "Height: \(pokemon.height) m"
        pokeWeightLabel.text = "Weight: \(pokemon.weight) g"
        pokemon.abilities.forEach { ability in
            if !ability.isHidden {
                pokeAbilityLabel.text = ("\(ability.ability.name)\n").capitalizingFirstLetter()
            } else{
                pokeHiddenAbilityLabel.text = ("\(ability.ability.name)\n").capitalizingFirstLetter()
            }
        }
    }
}
