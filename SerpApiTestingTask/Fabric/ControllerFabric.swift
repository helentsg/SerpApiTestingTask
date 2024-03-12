//
//  ControllerFabric.swift
//  VIPERTest
//
//  Created by Elena Lucher on 10.03.2024.
//

import UIKit

class ControllerFabric: NSObject {
    
    class func searchResultsVC()  -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsVC
        let router = SearchResultsRouter(controller: controller)
        let presenter = SearchResultsPresenter(view: controller,
                                               router: router)
        controller.presenter = presenter
        return controller
    }
    
//    class func detailedVC(for image: ImagesResult)  -> UIViewController {
//        let controller = DetailedViewController()
//        let router = DetailedRouter(controller: controller)
//        let presenter = DetailedPresenter(view: controller,
//                                          router: router,
//                                          image: image)
//        let interactor = DetailedInteractor(presenter: presenter,
//                                            image: image)
//        presenter.interactor = interactor
//        controller.presenter = presenter
//        return controller
//    }
//    
//    class func toolList(for type: ToolListType,
//                        delegate: ToolListPresenterProtocol)   -> UIViewController {
//        let controller = ToolListViewController()
//        let router =  ToolListRouter(controller: controller)
//        let presenter =  ToolListPresenter(view: controller,
//                                           router: router,
//                                           type: type,
//                                           delegate: delegate)
//        let interactor =  ToolListInteractor(presenter: presenter,
//                                             dataLoader: dataLoader)
//        presenter.interactor = interactor
//        controller.presenter = presenter
//        return controller
//    }
//    
//    class func webVC(for image: ImagesResult)   -> UIViewController {
//        let controller = WebViewController()
//        let presenter =  WebViewPresenter(view: controller,
//                                           image: image)
//        controller.presenter = presenter
//        return controller
//    }
    
}
