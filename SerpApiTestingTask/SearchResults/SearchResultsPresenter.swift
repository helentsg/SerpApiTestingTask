//
//  SearchResultsPresenter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 12.03.2024.
//

import UIKit

protocol SearchResultsPresenterProtocol: AnyObject {
    var currentCount: Int { get }
    var tools : Tools { set get }
    func selectedItem(for indexPath: IndexPath)
    func changeInList(for type: ToolListType)
    func fetchImages()
    func updateToolsButton()
    func height(for indexPath: IndexPath, and width: CGFloat) -> CGFloat 
    func image(for indexPath: IndexPath) -> ImagesResult
    var lastIndex: IndexPath { get }
}

class SearchResultsPresenter: NSObject, SearchResultsPresenterProtocol {
    
    private weak var view: SearchResultsViewProtocol?
    private var router: SearchResultsRouterProtocol!
    var tools = Tools()
    var images: [ImagesResult] = []
    private var currentPage = 0
    private var isLastPage = false
    private var isFetchInProgress = false
    let client = StackExchangeClient()
    var currentCount: Int {
        return images.count
    }
    var lastIndex: IndexPath {
        IndexPath(item: images.count - 1, section: 0)
    }
    
    init(view: SearchResultsViewProtocol,
         router: SearchResultsRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func selectedItem(for indexPath: IndexPath) {
        let image = images[indexPath.item]
        router.navigateToDetailedView(for: image)
    }
    
    func changeInList(for type: ToolListType) {
      //  router.navigateToToolList(for: type, delegate: self)
    }
    
}

extension SearchResultsPresenter {
    
    func fetchImages() {
      
      guard !isFetchInProgress, !isLastPage else {
        return
      }
      isFetchInProgress = true
        let request = ImagesRequest.from(tools: tools)
        client.fetchImages(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.view?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.isLastPage = response.serpapiPagination.next == nil
                    self.images.append(contentsOf: response.imagesResults)
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.imagesResults)
                        self.view?.onFetchCompleted(with: indexPathsToReload)
                        print(indexPathsToReload)
                    } else {
                        self.view?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newImages: [ImagesResult]) -> [IndexPath] {
        let startIndex = images.count - newImages.count
        let endIndex = startIndex + newImages.count
        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }
    
}
 
extension SearchResultsPresenter {
    
    func updateToolsButton() {
        view?.setupToolsButton()
    }
    
    func height(for indexPath: IndexPath, and width: CGFloat) -> CGFloat {
        return images[indexPath.item].calculateHeight(for: width)
    }
    
    func image(for indexPath: IndexPath) -> ImagesResult {
        let image = images[indexPath.item]
        return image
    }
}
