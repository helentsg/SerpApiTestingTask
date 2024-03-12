//
//  UISearchBar+Extension.swift
//  VIPERTest
//
//  Created by Elena Lucher on 09.03.2024.
//

import UIKit

extension UISearchBar {
    
    func roundedUI(leadingInset: CGFloat = 0, trailingInset: CGFloat = 0) {
        setSearchFieldBackgroundImage(UIImage(), for: .normal)
        backgroundColor = .white
        showsCancelButton = false
        autocapitalizationType = .none
        backgroundImage = UIImage()
        let image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        tintColor = .systemMint
        setImage(image, for: .clear, state: .normal)
        if let searchTextField = value(forKey: "searchField") as? UITextField {
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            searchTextField.textColor = .black
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 44),
                searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
                searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingInset),
                searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            searchTextField.clipsToBounds = true
            searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            searchTextField.layer.cornerRadius = 10.0
            searchTextField.layer.borderWidth = 1.0
            searchTextField.layer.borderColor = UIColor(red: 0.824, green: 0.82, blue: 0.82, alpha: 1).cgColor
        }
    }
    
}

