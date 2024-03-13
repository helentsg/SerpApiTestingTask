//
//  DetailedRouter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 13.03.2024.
//

import Foundation

import UIKit

protocol DetailedRouterProtocol {
    func navigateToWebView(for image: ImagesResult)
}


class DetailedRouter: DetailedRouterProtocol {
    
    private weak var controller: UIViewController?
    
    // MARK: Init
    
    required init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Protocol methods
    func navigateToWebView(for image: ImagesResult) {
//        let controller = ControllerFabric.webVC(for: image)
//        let navigationController = self.controller?.navigationController
//        navigationController?.pushViewController(controller,
//                                                 animated: true)
    }

    
}
