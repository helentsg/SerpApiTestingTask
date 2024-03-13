
import UIKit

protocol ToolListRouterProtocol {
    func close()
}


class ToolListRouter: ToolListRouterProtocol {
    
    private weak var controller: UIViewController?
    
    // MARK: Init
    
    required init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Protocol methods
    
    func close() {
        controller?.dismiss(animated: true)
    }
    
}


