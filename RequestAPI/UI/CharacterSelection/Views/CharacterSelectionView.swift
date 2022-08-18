//
//  CharacterSelectionView.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 29/11/21.
//

import UIKit

// MARK: - PROTOCOLS

protocol CharacterSelectionViewDelegate: AnyObject {
    func request(with requestType: RequestType, for characterNumber: Int)
    func showCharacterList()
}

class CharacterSelectionView: UIView {
    
    // MARK: - UI
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var characterNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.width * 3/4, height: 48)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Character number"
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    private lazy var urlSessionRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width * 3/4, height: 48)
        button.backgroundColor = .black
        button.setTitle("Request with URLSession", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(requestWithURLSession), for: .touchUpInside)
        return button
    }()
    
    private lazy var alamofireRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Request with Alamofire", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(requestWithAlamofire), for: .touchUpInside)
        return button
    }()
    
    private lazy var showFullListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("Show full list", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showFullList), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorPopUpView: ErrorPopUpView = {
        let view = ErrorPopUpView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: CharacterSelectionViewDelegate?
    
    // MARK: - LIFE CYCLE
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        dismissKeyboard()
        setupViewHierarchy()
        setupConstraints()
    }
    
    // MARK: - SETUP
    
    private func setupView() {
        backgroundColor = .systemOrange
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewHierarchy() {
        addSubview(characterNumberTextField)
        addSubview(urlSessionRequestButton)
        addSubview(alamofireRequestButton)
        addSubview(showFullListButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterNumberTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterNumberTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 96),
            characterNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            characterNumberTextField.heightAnchor.constraint(equalToConstant: 48),

            urlSessionRequestButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            urlSessionRequestButton.topAnchor.constraint(equalTo: characterNumberTextField.bottomAnchor, constant: 24),
            urlSessionRequestButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            urlSessionRequestButton.heightAnchor.constraint(equalToConstant: 48),

            alamofireRequestButton.topAnchor.constraint(equalTo: urlSessionRequestButton.bottomAnchor, constant: 24),
            alamofireRequestButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            alamofireRequestButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            alamofireRequestButton.heightAnchor.constraint(equalToConstant: 48),
            
            showFullListButton.topAnchor.constraint(equalTo: alamofireRequestButton.bottomAnchor, constant: 24),
            showFullListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            showFullListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            showFullListButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func showErrorPopUp() {
        addSubview(errorPopUpView)
        NSLayoutConstraint.activate([
            errorPopUpView.topAnchor.constraint(equalTo: topAnchor),
            errorPopUpView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorPopUpView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorPopUpView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        errorPopUpView.isHidden = false
    }

    // MARK: - PUBLIC FUNCTIONS
    
    func dismissPopUp() {
        errorPopUpView.isHidden = true
        errorPopUpView.removeFromSuperview()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }
    
    private func isNumberValid(_ characterNumber: Int) -> Bool {
        switch characterNumber {
        case 0, 83...: return false
        default: return true
        }
    }
    
    // MARK: - ACTIONS
    
    @objc private func requestWithURLSession() {
        guard let characterNumber = Int(characterNumberTextField.text ?? "0") else { return }
        isNumberValid(characterNumber) ?
        delegate?.request(with: .urlsession, for: characterNumber) :
        showErrorPopUp()
    }
    
    @objc private func requestWithAlamofire() {
        guard let characterNumber = Int(characterNumberTextField.text ?? "0") else { return }
        isNumberValid(characterNumber) ?
        delegate?.request(with: .alamofire, for: characterNumber) :
        showErrorPopUp()
    }
    
    @objc private func showFullList() {
        delegate?.showCharacterList()
    }
}

// MARK: - TEXT FIELD DELEGATE

extension CharacterSelectionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let characterNumber = characterNumberTextField.text,
           characterNumber.isEmpty {
            urlSessionRequestButton.isEnabled = false
            alamofireRequestButton.isEnabled = false
        } else {
            urlSessionRequestButton.isEnabled = true
            alamofireRequestButton.isEnabled = true
        }
    }
}

// MARK: - ERROR POPUP VIEW DELEGATE

extension CharacterSelectionView: ErrorPopUpViewDelegate {
    func dismiss() {
        dismissPopUp()
    }
}
