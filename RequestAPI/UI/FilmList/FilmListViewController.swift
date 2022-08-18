//
//  FilmListViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 02/12/21.
//

import UIKit
import RxSwift

class FilmListViewController: UITableViewController, FilmListViewControllerProtocol {

    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private var films: [String]?
    
    // MARK: - PUBLIC PROPERTIES
    
    public var viewModel: FilmListViewModelProtocol
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: FilmListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        bindObservables()
        viewModel.fetchFilmData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - PRIVATE SETUP
    
    private func bindObservables() {
        viewModel.viewStateObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleViewStateObserver($0)
        }
        
        viewModel.filmDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleFilmDataObserver($0)
        }
    }
    
    // MARK: - HANDLERS
    
    private func handleViewStateObserver(_ state: State) {
        switch state {
        case .loading:
            self.view.showBlurLoader()
        case .idle:
            self.view.removeBlurLoader()
        }
    }
    
    private func handleFilmDataObserver(_ data: Character) {
        self.films = data.films
        reloadData()
    }
    
    // MARK: - SETUP
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Films"
        navigationItem.leftBarButtonItem?.title = "Detail"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TABLEVIEW DATASOURCE

extension FilmListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let films = films else { return 1 }
        return films.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilmTableViewCell
        guard let films = films else {
            cell.titleLabel.text = "Impossible. Perhaps the archives are incomplete."
            return cell
        }
        cell.titleLabel.text = viewModel.convertFilmData(with: films[indexPath.row]) 
        return cell
    }
}
