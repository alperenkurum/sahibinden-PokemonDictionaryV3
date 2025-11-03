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
    
    private var collectionViewPokemon: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var isChecked: Bool = false
    private var isLoading: Bool = true
    private var isComparing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.onLoad()
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
        let action = isComparing ? UIAction{[weak self] _ in
                    self?.goComparing()
                } : UIAction{[weak self] _ in
                    self?.startComparing()
                }
        
        let barButtonItem = isComparing ? UIBarButtonItem.SystemItem.action : UIBarButtonItem.SystemItem.compose
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: barButtonItem, primaryAction: action)
    }
    
    private func setLeftNavBarButton() {
        let barButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction{[weak self] _ in self?.cancelComparing() })
        barButtonItem.isHidden = !isComparing
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func startComparing() {
        isComparing.toggle()
        configureNavigationBar()
        collectionViewPokemon.reloadData()
    }

    private func goComparing() {
        if(presenter.getSelectedIdListCount() < 3){
            return
        }else if (presenter.getSelectedIdListCount() == 3){
            let detailViewController = createDetailViewControllerMultiple()
            navigationController?.pushViewController(detailViewController, animated: true)
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
        collectionViewPokemon.translatesAutoresizingMaskIntoConstraints = false
        collectionViewPokemon.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionViewPokemon.delegate = self
        collectionViewPokemon.dataSource = self
        collectionViewPokemon.pin(to: view)
        collectionViewPokemon.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        var size : CGFloat = 0
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        size = (view.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
        
        if UIDevice.current.orientation.isPortrait{
            size = (view.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
        }else if UIDevice.current.orientation.isLandscape{
            size = (view.frame.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
        }
        layout.itemSize = CGSize(width: size, height: size)
        collectionViewPokemon = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionViewPokemon)
    }

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPokemonCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            fatalError("Failed to dequeue MainCollectionViewCell")
        }
        //TODO: -fill the cell after apicall for image
        let pokemon = presenter.getPokemon(index: indexPath.row)
        cell.set(with: pokemon.sprites.frontDefault, with: pokemon.name.capitalizingFirstLetter(),check: isChecked, id: pokemon.id, selectionStarted: isComparing)
        cell.delegateSelection = self
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = createDetailViewControllerSingle(with: indexPath.row)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func createDetailViewControllerSingle(with index: Int) -> DetailViewController {
        let detailModule = DetailModule()
        let pokemon = presenter.getPokemon(index: index)
        let detailViewController = detailModule.build(with: [pokemon.id])
        return detailViewController
    }
    
    private func createDetailViewControllerMultiple() -> DetailViewController {
        let detailModule = DetailModule()
        let selectedIdList = presenter.selectedIdList
        let detailViewController = detailModule.build(with: selectedIdList)
        return detailViewController
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            guard let self = self else { return }
            guard let layout = collectionViewPokemon.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                let size = (collectionViewPokemon.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
                layout.itemSize = CGSize(width: size, height: size)
                layout.invalidateLayout()
            case .landscapeLeft, .landscapeRight:
                let size = (collectionViewPokemon.frame.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
                layout.itemSize = CGSize(width: size, height: size)
                layout.invalidateLayout()
            case .unknown:
                printContent("Unknown orientation")
            case .faceUp:
                printContent("Face up orientation")
            case .faceDown:
                printContent("Face down orientation")
            @unknown default:
                print("default")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastItemIndex && isLoading {
            guard let newIndexPaths = presenter?.loadMorePokemons() else { return }
            self.collectionViewPokemon.insertItems(at: newIndexPaths)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as! LoadingFooterView
            if !isLoading {
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
        return presenter.selectedIdList.count
    }
    func selectionChanged(ID id: Int) {
        if !presenter.selectedIdList.contains(id){
            presenter.selectedIdList.append(id)
        }else{
            guard let position = presenter.selectedIdList.firstIndex(of: id)else{ return }
            presenter.selectedIdList.remove(at: position)
        }
    }
}

// MARK: - Introduction Presenter to View
extension MainViewController: MainPresenterToView {
    func toggleLoading() {
        isLoading.toggle()
    }
    
    func reloadPokemonData() {
        DispatchQueue.main.async {
            self.collectionViewPokemon.reloadData()
        }

    }
}
