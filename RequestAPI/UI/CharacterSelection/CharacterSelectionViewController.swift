//
//  CharacterSelectionViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 29/11/21.
//

import UIKit

// MARK: - PROTOCOLS

protocol CharacterSelectionViewControllerDelegate: AnyObject {
    func showCharacterDetail(model: CharacterDetailModel)
    func showFullCharacterList()
}

class CharacterSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var characterSelectionView: CharacterSelectionView = {
        let view = CharacterSelectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: CharacterSelectionViewControllerDelegate?
    
    // MARK: - LIFE CYCLE
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupViewHierarchy()
        dismissKeyboard()
        setupConstraints()
    }
    
    // MARK: - SETUP
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Fetch Data"
    }
    
    private func setupView() {
        view.backgroundColor = .systemOrange
    }
    
    private func setupViewHierarchy() {
        view.addSubview(characterSelectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterSelectionView.topAnchor.constraint(equalTo: view.topAnchor),
            characterSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - VIEW DELEGATE

extension CharacterSelectionViewController: CharacterSelectionViewDelegate {
    func request(with requestType: RequestType, for characterNumber: Int) {
        let model = CharacterDetailModel(requestType: requestType,
                                         characterNumber: characterNumber)
        delegate?.showCharacterDetail(model: model)
    }
    
    func showCharacterList() {
        
        delegate?.showFullCharacterList()
    }
}
