//
//  CharacterDetailViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 30/11/21.
//

import UIKit
import RxSwift

class CharacterDetailViewController: UIViewController, CharacterDetailViewControllerProtocol {
    
    // MARK: - UI
    
    private lazy var myLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: 400)
        return layout
    }()
    
    private lazy var myCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: myLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterDetailCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        collectionView.backgroundColor = .systemOrange
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private var character: Character?
    private var homeworld: Homeworld?

    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: CharacterDetailViewControllerDelegate?
    public var viewModel: CharacterDetailViewModelProtocol
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: CharacterDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bindObservables()
        viewModel.fetchCharacterData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
    }
    
    // MARK: - PRIVATE SETUP
    
    private func bindObservables() {
        viewModel.viewStateObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleViewStateObserver($0)
        }
        
        viewModel.characterDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleCharacterDataObserver($0)
        }
        
        viewModel.homeworldDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleHomeworldDataObserver($0)
        }
    }
    
    // MARK: - HANDLERS
    
    private func handleViewStateObserver(_ state: State) {
        switch state {
        case .loading:
            view.showBlurLoader()
        case .idle:
            view.removeBlurLoader()
        }
    }
    
    private func handleCharacterDataObserver(_ data: Character) {
        character = data
        viewModel.fetchHomeworld(with: data.homeworld)
    }
    
    private func handleHomeworldDataObserver(_ data: Homeworld) {
        homeworld = data
        reloadData()
    }

    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .systemOrange
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Character Detail"
    }
    
    private func setupViewHierarchy() {
        view.addSubview(myCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - PRIVATE METHODS
    
    private func setupCell(_ cell: CharacterDetailCollectionViewCell, at index: Int) {
        let character = self.character
        cell.characterNumber = index + 1
        cell.nameLabel.text = character?.characterName
        cell.heightLabel.text = character?.characterHeight
        cell.massLabel.text = character?.characterMass
        cell.genderLabel.text = character?.characterGender
        cell.birthYearLabel.text = character?.characterBirthYear
        cell.homeworldLabel.text = "Homeworld:"
        cell.delegate = self
        if let homeworld = homeworld {
            cell.homeworldNameLabel.text = homeworld.homeworldName
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
}

// MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CharacterDetailCollectionViewCell
        setupCell(cell, at: indexPath.row)
        return cell
    }
}

// MARK: - CELL DELEGATE

extension CharacterDetailViewController: UICollectionViewCellDelegate {
    func showStarshipList(model: StarshipListModel) {
        delegate?.showStarshipList(model: model)
    }
    
    func showFilmList(model: FilmListModel) {
        delegate?.showFilmList(model: model)
    }
}
