//
//  CharacterDetailCell.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 30/11/21.
//

import UIKit

protocol UICollectionViewCellDelegate: AnyObject {
    func showStarshipList(requestType: RequestType, characterNumber: Int)
    func showFilmList(requestType: RequestType, characterNumber: Int)
}

class CharacterDetailCollectionViewCell: UICollectionViewCell {
        
    // MARK: - UI
    
    lazy var nameLabel: UILabel = .titleLabel()
    lazy var heightLabel: UILabel = .regularLabel()
    lazy var massLabel: UILabel = .regularLabel()
    lazy var birthYearLabel: UILabel = .regularLabel()
    lazy var genderLabel: UILabel = .regularLabel()
    lazy var homeworldLabel: UILabel = .regularLabel()
    lazy var homeworldNameLabel: UILabel = .regularLabel()
    
    lazy var starshipsButton: UIButton = {
        let button = ButtonWithImage()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitle("Starships", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showStarshipList), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    lazy var filmsButton: UIButton = {
        let button = ButtonWithImage()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitle("Films", for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(showFilmList), for: .touchUpInside)
        button.tintColor = .white
        button.isEnabled = true
        return button
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: UICollectionViewCellDelegate?
    public var characterNumber = 0
    public var requestType: RequestType = .alamofire

    // MARK: - LIFE CYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        backgroundColor = .systemOrange
        translatesAutoresizingMaskIntoConstraints = false
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(heightLabel)
        contentView.addSubview(massLabel)
        contentView.addSubview(genderLabel)
        contentView.addSubview(birthYearLabel)
        contentView.addSubview(homeworldLabel)
        contentView.addSubview(homeworldNameLabel)
        contentView.addSubview(starshipsButton)
        contentView.addSubview(filmsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            
            heightLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            heightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            heightLabel.trailingAnchor.constraint(equalTo: massLabel.leadingAnchor, constant: -16),
            
            massLabel.centerYAnchor.constraint(equalTo: heightLabel.centerYAnchor),
            massLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            massLabel.widthAnchor.constraint(equalTo: heightLabel.widthAnchor),
            
            genderLabel.centerXAnchor.constraint(equalTo: heightLabel.centerXAnchor),
            genderLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 24),
            genderLabel.trailingAnchor.constraint(equalTo: birthYearLabel.leadingAnchor, constant: -16),
            
            birthYearLabel.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            birthYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            birthYearLabel.widthAnchor.constraint(equalTo: genderLabel.widthAnchor),
            
            homeworldLabel.centerXAnchor.constraint(equalTo: genderLabel.centerXAnchor),
            homeworldLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 24),
            homeworldLabel.trailingAnchor.constraint(equalTo: homeworldNameLabel.leadingAnchor, constant: -16),
            
            homeworldNameLabel.centerYAnchor.constraint(equalTo: homeworldLabel.centerYAnchor),
            homeworldNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            homeworldNameLabel.widthAnchor.constraint(equalTo: homeworldLabel.widthAnchor),
            
            starshipsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starshipsButton.topAnchor.constraint(equalTo: homeworldLabel.bottomAnchor, constant: 24),
            starshipsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            starshipsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            starshipsButton.heightAnchor.constraint(equalToConstant: 48),
            
            filmsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filmsButton.topAnchor.constraint(equalTo: starshipsButton.bottomAnchor, constant: 24),
            filmsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            filmsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            filmsButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    // MARK: - ACTIONS
    @objc private func showStarshipList() {
        delegate?.showStarshipList(requestType: requestType, characterNumber: characterNumber)
    }
    
    @objc private func showFilmList() {
        delegate?.showFilmList(requestType: requestType, characterNumber: characterNumber)
    }
}


