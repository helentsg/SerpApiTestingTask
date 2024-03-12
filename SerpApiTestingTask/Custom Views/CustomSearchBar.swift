//
//  CustomSearchBar.swift
//  VIPERTest
//
//  Created by Elena Lucher on 09.03.2024.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
       roundedUI()
    }
    
}
