
import UIKit

class ControllerFabric: NSObject {
    
    class func searchResultsVC()  -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchResultsVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultsVC") as! SearchResultsVC
        let router = SearchResultsRouter(controller: controller)
        let presenter = SearchResultsPresenter(view: controller,
                                               router: router)
        controller.presenter = presenter
        return controller
    }
    
    class func detailedPageVC(for image: ImagesResult,
                              delegate: SearchResultsPresenterProtocol)   -> UIPageViewController {
        let storyboard = UIStoryboard(name: "DetailedPageVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailedPageVC") as! DetailedPageVC
        let router = DetailedPageRouter(controller: controller)
        let presenter =  DetailedPagePresenter(view: controller,
                                               router: router,
                                               image: image,
                                               delegate: delegate)
        controller.presenter = presenter
        return controller
    }
    
    class func detailedVC(for image: ImagesResult)   -> DetailedVC {
        let storyboard = UIStoryboard(name: "DetailedVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedVC
        let router = DetailedRouter(controller: controller)
        let presenter =  DetailedPresenter(view: controller,
                                           router: router,
                                           image: image)
        controller.presenter = presenter
        return controller
    }
    
    class func toolList(for type: ToolListType,
                        delegate: SearchResultsPresenterProtocol)   -> UIViewController {
        let storyboard = UIStoryboard(name: "ToolListVC", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ToolListVC") as! ToolListVC
        let router = ToolListRouter(controller: controller)
        let presenter =  ToolListPresenter(view: controller,
                                                   router: router,
                                                   type: type,
                                                   delegate: delegate)
        controller.presenter = presenter
        return controller
    }

}
