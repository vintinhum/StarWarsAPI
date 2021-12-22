//
//  StarshipTableViewController.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 06/12/21.
//

import UIKit
import RxSwift

class StarshipListTableViewController: UITableViewController {

    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private var starships: [String] = []
    private var state: State

    // MARK: - PUBLIC PROPERTIES
    
    public var viewModel: StarshipListViewModel
    public var characterNumber = 0
    public var requestType: RequestType = .alamofire
    
    // MARK: - LIFE CYCLE
    
    init(requestType: RequestType, characterNumber: Int, viewModel: StarshipListViewModel) {
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
        fetchStarshipData()
        manageActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StarshipTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
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
        
        viewModel.starshipDataObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.starships = $0.starships
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Starships"
        navigationItem.leftBarButtonItem?.title = "Detail"
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func fetchStarshipData() {
        viewModel.fetchStarshipData(requestType: self.requestType, for: self.characterNumber) { data in
            self.starships = data.starships
        }
    }
}

// MARK: - TABLEVIEW DATASOURCE

extension StarshipListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if starships != [] {
            return self.starships.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StarshipTableViewCell
        if starships != [] {
            cell.titleLabel.text = starships[indexPath.row]
        } else {
            cell.titleLabel.text = "Impossible. Perhaps the archives are incomplete."
        }
        return cell
    }
}
