

import UIKit

protocol DetailedPageRouterProtocol {
    func navigateBackToList()
    func navigateToPreviousView(for image: ImagesResult)
    func navigateToNextView(for image: ImagesResult)
    func navigateToWebView(for image: ImagesResult)
}

class DetailedPageRouter: DetailedPageRouterProtocol {
    
    private weak var controller: UIViewController?
    
    // MARK: Init
    
    required init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Protocol methods
    
    func navigateBackToList() {
        let navigationController = self.controller?.navigationController
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToPreviousView(for image: ImagesResult) {
        
    }
    
    func navigateToNextView(for image: ImagesResult) {
        
    }
    
    func navigateToWebView(for image: ImagesResult) {
//        let controller = ControllerFabric.webVC(for: image)
//        let navigationController = self.controller?.navigationController
//        navigationController?.pushViewController(controller,
//                                                 animated: true)
    }
    
}
