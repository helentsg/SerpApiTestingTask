

import UIKit

protocol DetailedPageRouterProtocol {
    func navigateBackToList()
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
    
}
