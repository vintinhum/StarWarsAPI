//
//  CharacterListViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import UIKit
import RxSwift

class CharacterListViewController: UIViewController, CharacterListViewControllerProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private var characters: [Character]?
    private var homeworlds: [Homeworld]?
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: CharacterListViewControllerDelegate?
    public var viewModel: CharacterListViewModelProtocol
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: CharacterListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
        bindObservables()
        viewModel.retrieveCharacters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var myLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 350)
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
    
    // MARK: - PRIVATE SETUP
    
    private func bindObservables() {
        viewModel.viewStateObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleViewStateObserver($0)
        }
        
        viewModel.characterListDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleCharacterListDataObserver($0)
        }
        
        viewModel.homeworldListDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleHomeworldsDataObserver($0)
        }
    }
    
    // MARK: - HANDLERS
    
    private func handleViewStateObserver(_ state: State) {
        switch state {
        case .idle:
            self.view.removeBlurLoader()
        case .loading:
            self.view.showBlurLoader()
        }
    }
    
    private func handleCharacterListDataObserver(_ data: [Character]) {
        characters = data
        viewModel.retrieveHomeworlds(for: data)
    }
    
    private func handleHomeworldsDataObserver(_ data: [Homeworld]) {
        homeworlds = data
        reloadData()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        view.backgroundColor = .systemOrange
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Character List"
    }
    
    private func setupViewHierarchy() {
        view.addSubview(myCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupCell(_ cell: CharacterDetailCollectionViewCell, at index: Int) {
        guard let characters = characters, let homeworlds = homeworlds else { return }
        let character = characters[index]
        cell.characterNumber = index + 1
        cell.nameLabel.text = character.characterName
        cell.heightLabel.text = character.characterHeight
        cell.massLabel.text = character.characterMass
        cell.genderLabel.text = character.characterGender
        cell.birthYearLabel.text = character.characterBirthYear
        cell.homeworldLabel.text = "Homeworld:"
        cell.homeworldNameLabel.text = homeworlds[index].homeworldName
        cell.delegate = self
        cell.backgroundColor = .white
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionViewDelegate

extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let characters = characters else {
            return 1
        }
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CharacterDetailCollectionViewCell
        setupCell(cell, at: indexPath.row)
        return cell
    }
}

// MARK: - CollectionViewCellDelegate

extension CharacterListViewController: UICollectionViewCellDelegate {
    func showStarshipList(model: StarshipListModel) {
        delegate?.goToStarshipList(model: model)
    }
    
    func showFilmList(model: FilmListModel) {
        delegate?.goToFilmList(model: model)
    }
}
