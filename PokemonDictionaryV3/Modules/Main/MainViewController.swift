//
//  MainViewController.swift
//  PokemonDictionaryV3
//
//  Created by Ibrahim Alperen Kurum on 24.10.2025.
//

import UIKit

// MARK: - Introduction ViewController
final class MainViewController: UIViewController, MainView {
    // swiftlint:disable implicitly_unwrapped_optional
    var presenter: MainViewToPresenter!
    // swiftlint:enable implicitly_unwrapped_optional
    
    private var collectionViewPokemon: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!
    
    private var isChecked: Bool = false
    private var isLoading: Bool = true
    private var isComparing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter.onLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayoutForCurrentOrientation()
    }
    
    private func updateLayoutForCurrentOrientation() {
        guard let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let inset = layout.sectionInset.left + layout.sectionInset.right
        let spacing = layout.minimumInteritemSpacing

        let width = collectionViewPokemon.bounds.width

        if width == 0 { return } 

        let columns: CGFloat = UIDevice.current.orientation.isPortrait ? 2 : 3

        let itemWidth = (width - inset - (spacing * (columns - 1))) / columns

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.invalidateLayout()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewPokemon.collectionViewLayout.invalidateLayout()
        coordinator.animate { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.checkRotation()
            }
            
        }
    }
    
    private func checkRotation(){
        guard let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            let insetSpacing = layout.sectionInset.left + layout.sectionInset.right
            let size = (collectionViewPokemon.frame.width - insetSpacing - (2 * layout.minimumInteritemSpacing)) / 2
            layout.itemSize = CGSize(width: size, height: size)
            //layout.invalidateLayout()
        case .landscapeLeft, .landscapeRight:
            let size = (collectionViewPokemon.frame.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
            layout.itemSize = CGSize(width: size, height: size)
            //layout.invalidateLayout()
        case .unknown:
            print("Unknown orientation")
        case .faceUp:
            print("Face up orientation")
        case .faceDown:
            print("Face down orientation")
        @unknown default:
            print("default")
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Pokemon Dictionary"
        setRightNavBarButton()
        setLeftNavBarButton()
    }
    
    private func setRightNavBarButton() {
        let triggerCompare = UIAction{ [weak self] _ in
            self?.goComparing()
        }
        let startCompare = UIAction{[weak self] _ in
            self?.startComparing()
        }
        let action = isComparing ? triggerCompare: startCompare
        
        let barButtonItem: UIBarButtonItem.SystemItem = isComparing ? .action : .compose
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: barButtonItem, primaryAction: action)
    }
    
    private func setLeftNavBarButton() {
        let action = UIAction{ [weak self] _ in
            self?.cancelComparing()
        }
        let barButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: action)
        barButtonItem.isHidden = !isComparing
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func startComparing() {
        isComparing.toggle()
        configureNavigationBar()
        collectionViewPokemon.reloadData()
    }

    private func goComparing() {
        guard presenter.getSelectedIdListCount() >= 3 else { return }
        if (presenter.getSelectedIdListCount() == 3) {
            presenter.didStartedComparing()
        }
    }

    private func cancelComparing() {
        isComparing.toggle()
        presenter.removeAllSelectedIdList()
        collectionViewPokemon.reloadData()
        configureNavigationBar()
    }
    
    private func configureCollectionView() {
        setupCollectionView()
        collectionViewPokemon.backgroundColor = .systemBackground
        collectionViewPokemon.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionViewPokemon.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                       withReuseIdentifier: LoadingFooterView.identifier)
        collectionViewPokemon.delegate = self
        collectionViewPokemon.dataSource = self
        collectionViewPokemon.pin(to: view)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        // BOYUT -> viewDidLayoutSubviews'DA BELİRLERSİN
        layout.itemSize = .zero

        collectionViewPokemon = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewPokemon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionViewPokemon)
    }

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getPokemonCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Failed to dequeue MainCollectionViewCell")
        }
        //TODO: -fill the cell after apicall for image
        let pokemon = presenter.getPokemon(index: indexPath.row)
        let uiModel = MainCollectionViewCellUIModel(imageURL: pokemon.sprites.frontDefault, title: pokemon.name.capitalizingFirstLetter(), check: isChecked, id: pokemon.id, selectionStarted: isComparing)
        cell.set(uiModel: uiModel)
        cell.delegateSelection = self
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        guard indexPath.row == lastItemIndex && !isLoading,
              let newIndexPaths = presenter?.loadMorePokemons() else { return }
        self.collectionViewPokemon.insertItems(at: newIndexPaths)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            if isLoading {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - OnSeletionDelegate Protocol nereye alcam la bunu
extension MainViewController: OnSelectionDelegate{
    func getCount() -> Int {
        presenter.selectedIdList.count
    }
    
    func selectionChanged(ID id: Int) {
        if !presenter.selectedIdList.contains(id){
            presenter.selectedIdList.append(id)
        } else if let position = presenter.selectedIdList.firstIndex(of: id) {
            presenter.selectedIdList.remove(at: position)
        }
    }
}

// MARK: - Introduction Presenter to View
extension MainViewController: MainPresenterToView {
    func setLoading(with bool: Bool) {
        self.isLoading = bool
    }
    
    func reloadPokemonData() {
        DispatchQueue.main.async {
            self.collectionViewPokemon.reloadData()
        }
    }
}
