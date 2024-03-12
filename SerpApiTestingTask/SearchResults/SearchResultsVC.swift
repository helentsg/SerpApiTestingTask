//
//  SearchResultsVC.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 12.03.2024.
//

import UIKit

protocol SearchResultsViewProtocol: AnyObject, AlertDisplayer {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func setupToolsButton()
}

class SearchResultsVC: UIViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private var toolsMenu: UIMenu!
    private let indicatorView = UIActivityIndicatorView(style: .large)
    var presenter: SearchResultsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func didPullToRefresh(_ sender: UIRefreshControl) {
        
        collectionView.refreshControl?.endRefreshing()
    }
    
}

// MARK: SetupViewProtocol
extension SearchResultsVC {
    
    func setupViews() {
        setupControllerView()
        setupToolsButton()
        setupSearchBar()
        setupCollectionView()
        setupActivityIndicator()
    }
    
    func setupControllerView() {
        title = "List"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemMint
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Enter at least 3 simbols ..."
        searchBar.delegate = self
    }
    
    func setupCollectionView() {
        let layout = CustomLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.register(SearchResultsViewControllerCell.self, forCellWithReuseIdentifier: SearchResultsViewControllerCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = presenter
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        //        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        //        collectionView.refreshControl = refreshControl
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func setupActivityIndicator() {
        indicatorView.color = .systemMint
        view.addSubview(indicatorView)
        indicatorView.center = view.center
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.center = view.center
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchResultsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectedItem(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: CustomLayoutDelegate
extension SearchResultsVC: CustomLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            guard let presenter else { return 100 }
            let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
            let height = presenter.height(for: indexPath, and: width)
            return height
        }
}

// MARK: Tools Button Settings
private extension SearchResultsVC {
    
    func generateMenu(for tools: Tools) -> UIMenu {
        let engineMenu = generateMenu(for: tools.type)
        let sizeMenu = generateMenu(for: tools.size)
        let countryAction = generateCountryAction(for: tools.country)
        let languageAction = generateLanguageAction(for: tools.language)
        var children = [engineMenu, countryAction, languageAction]
        if tools.type == .image {
            /// Size is available for images:
            children.insert(sizeMenu, at: 1)
        } else {
            presenter?.tools.size = .any
        }
        return UIMenu(title: "Setup Search Tools:", children: children)
    }
    
    func generateMenu(for typeChosen: Tools.SearchType) -> UIMenu {
        let searchTypeActions = Tools.SearchType.allCases.map ({ type in
            let image = type == typeChosen ? UIImage(systemName: "checkmark") : nil
            return UIAction(title: "\(type.description)",
                            image: image,
                            handler: {[weak self] _ in
                self?.presenter?.tools.type = type
                self?.setupToolsButton()
            })
        })
        return UIMenu(title: "Choose type", children: searchTypeActions)
    }
    
    func generateMenu(for sizeChosen: Tools.Size) -> UIMenu {
        let sizeActions = Tools.Size.allCases.map ({ size in
            let image = size == sizeChosen ? UIImage(systemName: "checkmark") : nil
            return UIAction(title: "\(size.description)",
                            image: image,
                            handler: {[weak self] _ in
                self?.presenter?.tools.size = size
                self?.setupToolsButton()
            })
        })
        return UIMenu(title: "Choose size", children: sizeActions)
    }
    
    func generateCountryAction(for country: GoogleModel?) -> UIAction {
        let title = country == nil ? "Choose country" : "\(country!.name)"
        let image = country == nil ? nil : UIImage(systemName: "checkmark")
        return UIAction(title: title,
                        image: image,
                        handler: {[weak self] _ in
            self?.presenter?.changeInList(for: .country)
        })
    }
    
    func generateLanguageAction(for language: GoogleModel?) -> UIAction {
        let title = language == nil ? "Choose language" : "\(language!.name)"
        let image = language == nil ? nil : UIImage(systemName: "checkmark")
        return UIAction(title: title,
                        image: image,
                        handler: {[weak self] _ in
            self?.presenter?.changeInList(for: .language)
        })
    }
    
}

// MARK: UISearchBarDelegate
extension SearchResultsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        self.perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reload(searchBar)
    }
    
    @IBAction func reload(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            presenter?.tools.query = nil
            //    fetchContentList()
        }
        guard let query = searchBar.text?.lowercased(), query.trimmingCharacters(in: .whitespaces) != "", query.count > 2 else {
            return
        }
        presenter?.tools.query = query
        presenter?.fetchImages()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: ToolListViewInputProtocol
extension SearchResultsVC: SearchResultsViewProtocol {
    
    func setupToolsButton() {
        guard let tools = presenter?.tools else { return }
        let menu = generateMenu(for: tools)
        let toolsButton = UIBarButtonItem(title: "Tools",
                                          image: nil,
                                          target: self,
                                          action: nil,
                                          menu: menu)
        navigationItem.rightBarButtonItem = toolsButton
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
}

private extension SearchResultsVC {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        guard let currentCount = presenter?.currentCount else {
            return false
        }
        return indexPath.item >= currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension SearchResultsVC: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print (indexPaths)
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.fetchImages()
        }
    }
    
    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        
    }
    
}
