//
//  MainCollectionViewCell.swift
//  PokemonDictionaryV1
//
//  Created by Ibrahim Alperen Kurum on 21.10.2025.
//

import UIKit

struct MainCollectionViewCellUIModel {
    let imageURL: String
    let title: String
    let check: Bool
    let id: Int
    let selectionStarted: Bool
}

protocol OnSelectionDelegate: AnyObject {
    func selectionChanged(ID id: Int)
    func getCount() -> Int
}

class MainCollectionViewCell: UICollectionViewCell {
    weak var delegateSelection: OnSelectionDelegate?
    static let identifier = "MainCollectionViewCell"
    private var isChecked = false
    private var isEditting = false
    private var id: Int?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.backgroundColor = .systemMint
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private var selectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(uiModel: MainCollectionViewCellUIModel) {
        myImageView.load(with: uiModel.imageURL)
        titleLabel.text = uiModel.title
        isChecked = uiModel.check
        self.id = uiModel.id
        isEditting = uiModel.selectionStarted
        selectionButton.isHidden = !isEditting
        selectionButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    private func configureUI() {
        stackView.addArrangedSubview(myImageView)
        stackView.addArrangedSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(selectionButton)
        configureStackView()
        configureImageView()
        configureLabel()
        configureSelectionButton()
    }
    
    private func configureStackView() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
//            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            myImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8)
            myImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            myImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            myImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func configureLabel() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureSelectionButton(){
        selectionButton.isHidden = !isEditting
        let action = UIAction{ [weak self] _ in
            self?.buttonTapped()
        }
        selectionButton.addAction(action, for: .primaryActionTriggered)
    }
    private func buttonTapped(){
        guard let count = delegateSelection?.getCount(), let id else { return }
        if isChecked || count < 3 {
            isChecked.toggle()
            selectionButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle": "circle"), for: .normal)
            delegateSelection?.selectionChanged(ID: id)
        }
    }
}

