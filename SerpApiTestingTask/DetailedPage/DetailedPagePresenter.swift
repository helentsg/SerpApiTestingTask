

import UIKit

protocol DetailedPagePresenterProtocol: AnyObject {
    
    init(view: DetailedPageViewProtocol,
         router: DetailedPageRouterProtocol,
         image: ImagesResult,
         delegate: SearchResultsPresenterProtocol)
    func createPages()
    func navigateBackToList()
    func previousButtonTapped()
    func getPreviousVC() -> UIViewController?
    func nextButtonTapped()
    func getNextVC() -> UIViewController?
}

enum Page {
    case previous, current, next
}

class DetailedPagePresenter : DetailedPagePresenterProtocol {
    
    unowned var view: DetailedPageViewProtocol
    private var router: DetailedPageRouterProtocol!
    private var delegate: SearchResultsPresenterProtocol
    private var pages: [Page: DetailedVC? ] = [:]
    private var currentPosition: Int
    
    
    required init(view: DetailedPageViewProtocol,
                      router: DetailedPageRouterProtocol,
                      image: ImagesResult,
                      delegate: SearchResultsPresenterProtocol) {
        self.view = view
        self.router = router
        self.delegate = delegate
        currentPosition = image.position
    }
    
    func createPages() {
        if let currentImage = delegate.image(position: currentPosition) {
            pages[.current] = ControllerFabric.detailedVC(for: currentImage)
            if let mapped = pages[.current].flatMap({$0}) {
                view.set(pages: [mapped])
            }
        }
        if let previousImage = delegate.image(position: currentPosition - 1) {
            let previousPage = ControllerFabric.detailedVC(for: previousImage)
            pages[.previous] = previousPage
        }
        if let nextImage = delegate.image(position: currentPosition + 1) {
            let nextPage = ControllerFabric.detailedVC(for: nextImage)
            pages[.next] = nextPage
        }
    }
    
    func navigateBackToList() {
        router.navigateBackToList()
    }
    
    func previousButtonTapped() {
        currentPosition = currentPosition > 0 ? currentPosition - 1 : 0
        createPages()
    }
    
    func getPreviousVC() -> UIViewController? {
        if let prevVC = pages[.previous] {
            view.setupPreviousButton(isEnabled: true)
            return prevVC
        } else {
            view.setupPreviousButton(isEnabled: false)
            return nil
        }
    }
    
    func nextButtonTapped() {
        currentPosition += 1
        createPages()
    }
    
    func getNextVC() -> UIViewController? {
        if let nextVC = pages[.next] {
            view.setupNextButton(isEnabled: true)
            return nextVC
        } else {
            view.setupNextButton(isEnabled: false)
            return nil
        }
    }
    
}

