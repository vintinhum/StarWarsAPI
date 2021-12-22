//
//  CharacterDetailViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 30/11/21.
//

import UIKit
import RxSwift

protocol CharacterDetailCollectionViewControllerDelegate: AnyObject {
    func showStarshipList(requestType: RequestType, characterNumber: Int)
    func showFilmList(requestType: RequestType, characterNumber: Int)
}

class CharacterDetailCollectionViewController: UIViewController {
    
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
    private var state: State

    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: CharacterDetailCollectionViewControllerDelegate?
    public var viewModel: CharacterDetailViewModel
    public var characterNumber = 0
    public var requestType: RequestType = .alamofire
    
    // MARK: - LIFE CYCLE
    
    init(requestType: RequestType, characterNumber: Int, viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        self.state = .loading
        super.init(nibName: nil, bundle: nil)
        self.requestType = requestType
        self.characterNumber = characterNumber
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bindObservables()
        fetchCharacterDetails()
        manageActivityIndicator()
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
        viewModel.viewStateObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                self.state = state
                switch state {
                case .loading:
                    self.view.showBlurLoader()
                case .idle:
                    self.view.removeBlurLoader()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.characterDataObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.character = $0
                self.fetchHomeworld(requestType: self.requestType, url: $0.homeworld)
            })
            .disposed(by: disposeBag)
        
        viewModel.homeworldDataObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.homeworld = $0
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
    
    private func manageActivityIndicator() {
        let state = self.state
        switch state {
        case .loading:
            self.view.showBlurLoader()
        case .idle:
            self.view.removeBlurLoader()
        }
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

    // MARK: - PRIVATE FUNCTIONS
    
    private func fetchCharacterDetails() {
        viewModel.fetchCharacterData(requestType: self.requestType, for: self.characterNumber, completion: { data in
            self.character = data
        })
    }
    
    private func fetchHomeworld(requestType: RequestType, url: String) {
        viewModel.fetchHomeworld(requestType: requestType, url: url, completion: { data in
            self.homeworld = data
        })
    }
}

// MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE

extension CharacterDetailCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CharacterDetailCollectionViewCell
        let character = self.character
        cell.characterNumber = self.characterNumber
        cell.nameLabel.text = character?.characterName
        cell.heightLabel.text = character?.characterHeight
        cell.massLabel.text = character?.characterMass
        cell.genderLabel.text = character?.gender == "n/a" ? character?.characterGender.capitalized : character?.characterGender.firstCapitalized
        cell.birthYearLabel.text = character?.characterBirthYear
        cell.homeworldLabel.text = "Homeworld:"
        cell.delegate = self
        if let homeworldName = self.homeworld?.homeworldName {
            cell.homeworldNameLabel.text = homeworldName
        }
        return cell
    }
}

// MARK: - CELL DELEGATE

extension CharacterDetailCollectionViewController: UICollectionViewCellDelegate {
    func showStarshipList(requestType: RequestType, characterNumber: Int) {
        delegate?.showStarshipList(requestType: requestType, characterNumber: characterNumber)
    }
    
    func showFilmList(requestType: RequestType, characterNumber: Int) {
        delegate?.showFilmList(requestType: requestType, characterNumber: characterNumber)
    }
}
