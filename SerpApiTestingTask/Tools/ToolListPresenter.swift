//
//  ToolListPresenter.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 12.03.2024.
//

import Foundation

protocol ToolListPresenterProtocol: AnyObject {
    init(view: ToolListViewProtocol,
         router: ToolListRouterProtocol,
         type: ToolListType,
         delegate: SearchResultsPresenterProtocol)
    func showList()
    var type: ToolListType { get }
    var listCount: Int { get }
    var query: String? { get set }
    func listData(for indexPath: IndexPath) -> (model: GoogleModel, isSelected: Bool)
    func selectedRow(for indexPath: IndexPath)
    func clearSelection()
    func close()
}

class ToolListPresenter : ToolListPresenterProtocol {
    
    unowned let view: ToolListViewProtocol
    private var router: ToolListRouterProtocol!
    var type: ToolListType
    private let delegate: SearchResultsPresenterProtocol
    var query: String?
    private var list: [GoogleModel] = []
    let dataLoader: DataLoaderProtocol?
    var listCount: Int {
        list.count
    }
    
    required init(view: ToolListViewProtocol,
                  router: ToolListRouterProtocol,
                  type: ToolListType,
                  delegate: SearchResultsPresenterProtocol) {
        self.view = view
        self.router = router
        self.type = type
        self.delegate = delegate
        dataLoader = DataLoader()
    }
    
    func showList() {
        Task {
            guard let fetched =  try await dataLoader?.fetchModels(for: type) else {
                return
            }
            if let query, !query.isEmpty {
                let matching = fetched.filter({
                    $0.name.range(of: query, options: .caseInsensitive) != nil
                })
                list = matching
            } else {
                list = fetched
            }
            await updateUI()
        }
    }
    
    @MainActor func updateUI() {
        view.reloadList()
    }
    
    func listData(for indexPath: IndexPath) -> (model: GoogleModel, isSelected: Bool) {
        let index = indexPath.row
        let model = list[index]
        switch type {
        case .country:
            let isSelected = delegate.tools.country == model
            return (model: model, isSelected: isSelected)
        case .language:
            let isSelected = delegate.tools.language == model
            return (model: model, isSelected: isSelected)
        }
    }
    
    func selectedRow(for indexPath: IndexPath) {
        let model = list[indexPath.row]
        switch type {
        case .country:
            delegate.tools.country = model
        case .language:
            delegate.tools.language = model
        }
        delegate.updateToolsButton()
        router.close()
    }
    
    func clearSelection() {
        switch type {
        case .country:
            delegate.tools.country = nil
        case .language:
            delegate.tools.language = nil
        }
        delegate.updateToolsButton()
        router.close()
    }
    
    func close() {
        router.close()
    }
    
}
