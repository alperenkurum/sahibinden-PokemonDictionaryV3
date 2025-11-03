//
//  MainCollectionViewCell.swift
//  PokemonDictionaryV1
//
//  Created by Ibrahim Alperen Kurum on 21.10.2025.
//

import UIKit

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
    
    func set(with imageURL: String, with title: String, check: Bool, id: Int, selectionStarted: Bool) {
        myImageView.load(with: imageURL)
        titleLabel.text = title
        isChecked = check
        self.id = id
        isEditting = selectionStarted
        selectionButton.isHidden = !isEditting
        selectionButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    private func configureUI() {
        contentView.addSubview(myImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectionButton)
        configureImageView()
        configureLabel()
        configureSelectionButton()
    }
    
    private func configureImageView() {
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8)
            ])
    }
    
    private func configureLabel() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureSelectionButton(){
        selectionButton.isHidden = !isEditting
        let action = UIAction{[weak self] _ in
            self?.buttonTapped()
        }
        selectionButton.addAction(action, for: .primaryActionTriggered)
    }
    private func buttonTapped(){
        if isChecked || delegateSelection?.getCount() ?? 4 < 3{
            isChecked.toggle()
            selectionButton.setImage(UIImage(systemName: isChecked ? "checkmark.circle": "circle"), for: .normal)
            guard let id = id else { return }
            delegateSelection?.selectionChanged(ID: id)
        }
    }
}

