//
//  SearchResultsRouter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 12.03.2024.
//

import Foundation

import UIKit

protocol SearchResultsRouterProtocol {
    func navigateToDetailedView(for image: ImagesResult)
    func navigateToToolList(for type: ToolListType,
                            delegate: SearchResultsPresenterProtocol)
}


class SearchResultsRouter: SearchResultsRouterProtocol {
    
    private weak var controller: UIViewController?
    
    // MARK: Init
    required init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Protocol methods
    func navigateToDetailedView(for image: ImagesResult) {
//        let controller = ControllerFabric.detailedVC(for: image)
//        let navigationController = self.controller?.navigationController
//        navigationController?.pushViewController(controller,
//                                                 animated: true)
    }
    
    func navigateToToolList(for type: ToolListType,
                            delegate: SearchResultsPresenterProtocol) {
        let controller = ControllerFabric.toolList(for: type,
                                                   delegate: delegate)
        let navigationController = UINavigationController(rootViewController: controller)
        self.controller?.present(navigationController, animated: true)
    }
    
}
