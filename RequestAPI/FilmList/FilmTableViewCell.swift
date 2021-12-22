//
//  FilmTableViewCell.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 03/12/21.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    lazy var titleLabel: UILabel = .regularLabel()
        
    // MARK: - LIFE CYCLE
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
}
