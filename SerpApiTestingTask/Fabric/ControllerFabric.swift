
import UIKit

class ControllerFabric: NSObject {
    
    class func searchResultsVC()  -> UIViewController {
        let controller = SearchResultsVC()
        let router = SearchResultsRouter(controller: controller)
        let presenter = SearchResultsPresenter(view: controller,
                                               router: router)
        controller.presenter = presenter
        return controller
    }
    
    class func detailedPageVC(for image: ImagesResult,
                              delegate: SearchResultsPresenterProtocol)   -> UIPageViewController {
        let controller = DetailedPageVC()
        let router = DetailedPageRouter(controller: controller)
        let presenter =  DetailedPagePresenter(view: controller,
                                               router: router,
                                               image: image,
                                               delegate: delegate)
        controller.presenter = presenter
        return controller
    }
    
    class func detailedVC(for image: ImagesResult)   -> DetailedVC {
        let controller = DetailedVC()
        let router = DetailedRouter(controller: controller)
        let presenter =  DetailedPresenter(view: controller,
                                           router: router,
                                           image: image)
        controller.presenter = presenter
        return controller
    }
    
    class func toolList(for type: ToolListType,
                        delegate: SearchResultsPresenterProtocol)   -> UIViewController {
        let controller = ToolListVC()
        let router = ToolListRouter(controller: controller)
        let presenter =  ToolListPresenter(view: controller,
                                                   router: router,
                                                   type: type,
                                                   delegate: delegate)
        controller.presenter = presenter
        return controller
    }

}
