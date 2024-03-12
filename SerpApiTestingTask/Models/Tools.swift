//
//  MakeRequest.swift
//  VIPERTest
//
//  Created by Elena Lucher on 08.03.2024.
//

import Foundation

protocol Description {
    var description: String { get }
}

struct Tools {
    
    enum SearchType: String, CaseIterable, Description {
        
        case image = "isch"
        case video = "vid"
        
        var description: String {
            switch self {
            case .image:
                return "Images"
            case .video:
                return "Videos"
            }
        }
        
        var imageName: String {
            switch self {
            case .image:
                return "photo.circle"
            case .video:
                return "video.circle"
            }
        }
        
    }
    
    enum Size: String, CaseIterable, Description {
        case any = ""
        case large = "l"
        case medium = "m"
        case small = "s"
        case icon = "i"
        
        var description: String {
            switch self {
            case .any:
                return "Any"
            case .large:
                return "Large"
            case .medium:
                return "Medium"
            case .small:
                return "Small"
            case .icon:
                return "Icons"
            }
        }
        
    }
    
    var type: SearchType = .image
    var size: Size = .any
    var country: GoogleModel?
    var language: GoogleModel?
    var query: String?
    /// Pagination:
    var start: Int = 0
    var num: Int = 20
}
