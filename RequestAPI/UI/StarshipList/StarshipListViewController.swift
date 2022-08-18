//
//  StarshipListViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 06/12/21.
//

import UIKit
import RxSwift

class StarshipListViewController: UITableViewController, StarshipListViewControllerProtocol {

    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private var starships: [String]?

    // MARK: - PUBLIC PROPERTIES
    
    public var viewModel: StarshipListViewModelProtocol
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: StarshipListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bindObservables()
        viewModel.fetchStarshipData()
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
        
        viewModel.starshipDataObserver.subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleStarshipDataObserver($0)
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
    
    private func handleStarshipDataObserver(_ data: Character) {
        self.starships = data.starships
        reloadData()
    }
    
    // MARK: - SETUP
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Starships"
        navigationItem.leftBarButtonItem?.title = "Detail"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StarshipTableViewCell.self, forCellReuseIdentifier: "cell")
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

extension StarshipListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let starships = starships else { return 1 }
        return starships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StarshipTableViewCell
        guard let starships = starships else {
            cell.titleLabel.text = "Impossible. Perhaps the archives are incomplete."
            return cell
        }
        cell.titleLabel.text = starships[indexPath.row]
        return cell
    }
}
