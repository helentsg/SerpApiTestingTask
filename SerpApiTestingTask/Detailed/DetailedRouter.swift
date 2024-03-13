//
//  DetailedRouter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 13.03.2024.
//

import SafariServices
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
        if let url = URL(string: image.original) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            let navigationController = self.controller?.navigationController
            navigationController?.present(vc, animated: true)
        }
    }

}
