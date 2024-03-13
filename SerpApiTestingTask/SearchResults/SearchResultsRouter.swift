
import UIKit

protocol SearchResultsRouterProtocol {
    
    func navigateToToolList(for type: ToolListType,
                            delegate: SearchResultsPresenterProtocol)
    func navigateToDetailedPageView(for image: ImagesResult,
                                    delegate: SearchResultsPresenterProtocol)
}


class SearchResultsRouter: SearchResultsRouterProtocol {
    
    private weak var controller: UIViewController?
    
    // MARK: Init
    required init(controller: UIViewController) {
        self.controller = controller
    }
    
    // MARK: Protocol methods
    func navigateToDetailedPageView(for image: ImagesResult,
                                delegate: SearchResultsPresenterProtocol) {
        let controller = ControllerFabric.detailedPageVC(for: image, delegate: delegate)
        let navigationController = self.controller?.navigationController
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
    
    func navigateToToolList(for type: ToolListType,
                            delegate: SearchResultsPresenterProtocol) {
        let controller = ControllerFabric.toolList(for: type,
                                                   delegate: delegate)
        let navigationController = UINavigationController(rootViewController: controller)
        self.controller?.present(navigationController, animated: true)
    }
    
}
