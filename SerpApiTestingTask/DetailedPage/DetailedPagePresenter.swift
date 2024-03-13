//
//  DetailedPagePresenter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 13.03.2024.
//

import UIKit

protocol DetailedPagePresenterProtocol: AnyObject {
    
    init(view: DetailedPageViewProtocol,
         router: DetailedPageRouterProtocol,
         image: ImagesResult,
         delegate: SearchResultsPresenterProtocol)
    func createInitialPage()
    func change(currentPage newValue: Int)
    func navigateBackToList()
    func previousButtonTapped()
    func getPreviousVC() -> UIViewController?
    func nextButtonTapped()
    func getNextVC() -> UIViewController?
}

class DetailedPagePresenter : DetailedPagePresenterProtocol {
    
    unowned var view: DetailedPageViewProtocol
    private var router: DetailedPageRouterProtocol!
    private var image: ImagesResult
    private var delegate: SearchResultsPresenterProtocol
    private var pages: [DetailedVC] = []
    private var currentPageNumber = 1
    
    
    required init(view: DetailedPageViewProtocol,
                      router: DetailedPageRouterProtocol,
                      image: ImagesResult,
                      delegate: SearchResultsPresenterProtocol) {
        self.view = view
        self.router = router
        self.image = image
        self.delegate = delegate
        
    }
    
    func createInitialPage() {
        let initialPage = ControllerFabric.detailedVC(for: image)
        view.set(pages: [initialPage])
    }
    
    func change(currentPage newValue: Int) {
        
    }
    
    func navigateBackToList() {
        router.navigateBackToList()
    }
    
    func previousButtonTapped() {
        
    }
    
    func getPreviousVC() -> UIViewController? {
        if let previousImage = delegate.image(position: image.position - 1) {
            let previousPage = ControllerFabric.detailedVC(for: previousImage)
            view.setupPreviousButton(isEnabled: true)
            return previousPage
        } else {
            view.setupPreviousButton(isEnabled: false)
            return nil
        }
    }
    
    func nextButtonTapped() {
        
    }
    
    func getNextVC() -> UIViewController? {
        if let nextImage = delegate.image(position: image.position + 1) {
            let previousPage = ControllerFabric.detailedVC(for: nextImage)
            view.setupNextButton(isEnabled: true)
            return previousPage
        } else {
            view.setupNextButton(isEnabled: false)
            return nil
        }
    }
    
}

