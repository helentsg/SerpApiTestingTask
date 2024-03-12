//
//  ToolListType.swift
//  VIPERTest
//
//  Created by Elena Lucher on 09.03.2024.
//

import Foundation

enum ToolListType {
    case country, language
    
    var title: String {
        switch self {
        case .country:
            return "Choose country"
        case .language:
            return "Choose language"
        }
    }
    
    var searchBarPlaceholder: String {
        switch self {
        case .country:
            return "enter country name"
        case .language:
            return "enter language"
        }
    }
    
    var fileName: String {
        switch self {
        case .country:
            return "google-countries"
        case .language:
            return "google-languages"
        }
    }
    
}
