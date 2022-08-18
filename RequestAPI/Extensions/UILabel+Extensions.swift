//
//  UILabel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 01/12/21.
//

import UIKit

extension UILabel {
    static func titleLabel(text: String = "",
                           _ size: CGFloat = 22.0,
                           textColor: UIColor = .black,
                           numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    static func regularLabel(text: String = "",
                             _ size: CGFloat = 17.0,
                             textColor: UIColor = .black,
                             numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}
