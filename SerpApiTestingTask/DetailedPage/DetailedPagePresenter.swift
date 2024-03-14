

import UIKit

protocol DetailedPagePresenterProtocol: AnyObject {
    
    init(view: DetailedPageViewProtocol,
         router: DetailedPageRouterProtocol,
         image: ImagesResult,
         delegate: SearchResultsPresenterProtocol)
    func createPages()
    func navigateBackToList()
    func previousButtonTapped()
    func getPreviousVC() -> DetailedVC?
    func getCurrentVC() -> DetailedVC?
    func nextButtonTapped()
    func getNextVC() -> DetailedVC?
    var index: (current: Int, next: Int) { get set }
    func transitionCompleted()
}

enum Page {
    case previous, current, next
}

class DetailedPagePresenter : DetailedPagePresenterProtocol {
    
    unowned var view: DetailedPageViewProtocol
    private var router: DetailedPageRouterProtocol!
    private var delegate: SearchResultsPresenterProtocol
    private var pages: [Page: DetailedVC? ] = [:]
    var index: (current: Int, next: Int)
    
    required init(view: DetailedPageViewProtocol,
                      router: DetailedPageRouterProtocol,
                      image: ImagesResult,
                      delegate: SearchResultsPresenterProtocol) {
        self.view = view
        self.router = router
        self.delegate = delegate
        self.index = (current: image.position,
                      next: image.position + 1)
    }
    
    func createPages() {
        if let previousImage = delegate.image(position: index.current - 1) {
            let previousPage = ControllerFabric.detailedVC(for: previousImage)
            pages[.previous] = previousPage
        }
        if let currentImage = delegate.image(position: index.current) {
            let currentPage = ControllerFabric.detailedVC(for: currentImage)
            pages[.current] = currentPage
        }
        
        if let nextImage = delegate.image(position: index.current + 1) {
            let nextPage = ControllerFabric.detailedVC(for: nextImage)
            pages[.next] = nextPage
        }
    }
    
    func navigateBackToList() {
        router.navigateBackToList()
    }
    
    func previousButtonTapped() {
        index.current = index.current > 0 ? index.current - 1 : 0
        createPages()
    }
    
    func getCurrentVC() -> DetailedVC? {
        return pages[.current].flatMap({$0})
    }
    
    func getPreviousVC() -> DetailedVC? {
        if let prevVC = pages[.previous] {
            view.setupPreviousButton(isEnabled: true)
            return prevVC
        } else {
            view.setupPreviousButton(isEnabled: false)
            return nil
        }
    }
    
    func nextButtonTapped() {
        index.current = index.current + 1
        createPages()
    }
    
    func getNextVC() -> DetailedVC? {
        if let nextVC = pages[.next] {
            view.setupNextButton(isEnabled: true)
            return nextVC
        } else {
            view.setupNextButton(isEnabled: false)
            return nil
        }
    }
    
    func transitionCompleted() {
        print(index)
        index.current = index.next
        createPages()
    }
    
}

