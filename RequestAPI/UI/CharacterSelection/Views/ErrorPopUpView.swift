//
//  ErrorPopUpView.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 06/12/21.
//

import UIKit

protocol ErrorPopUpViewDelegate: AnyObject {
    func dismiss()
}

class ErrorPopUpView: UIView {

    // MARK: - UI
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var errorTitleLabel: UILabel = {
        let label: UILabel = .titleLabel(text: "ERROR")
        return label
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label: UILabel = .regularLabel(text: "Invalid character number.")
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ErrorPopUpViewDelegate?
    
    // MARK: - LIFE CYCLE
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupViewHierarchy()
        setupConstraints()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        frame = UIScreen.main.bounds
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewHierarchy() {
        addSubview(container)
        container.addSubview(errorTitleLabel)
        container.addSubview(errorMessageLabel)
        container.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3/4),
            
            errorTitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            errorTitleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            
            errorMessageLabel.centerXAnchor.constraint(equalTo: errorTitleLabel.centerXAnchor),
            errorMessageLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 24),
            
            dismissButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            dismissButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 16),
            dismissButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24),
        ])
    }

    // MARK: - ACTIONS
    
    @objc private func dismissPopUp() {
        delegate?.dismiss()
    }
}
