
import UIKit

protocol SearchResultsViewProtocol: AnyObject, AlertDisplayer {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func setupToolsButton()
}

class SearchResultsVC: UIViewController {
    
    private lazy var searchBar = CustomSearchBar()
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private lazy var indicatorView = UIActivityIndicatorView(style: .large)
    private var toolsMenu: UIMenu!
    
    var presenter: SearchResultsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

// MARK: SetupViewProtocol
extension SearchResultsVC: SetupViewProtocol {
    
    func setupViews() {
        setupControllerView()
        setupToolsButton()
        setupSearchBar()
        setupCollectionView()
        setupIndicatorView()
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.delegate = self
        collectionView.register(SearchResultsViewControllerCell.self, forCellWithReuseIdentifier: SearchResultsViewControllerCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isHidden = true
    }
    
    @IBAction func didPullToRefresh(_ sender: UIRefreshControl) {
        collectionView.refreshControl?.endRefreshing()
        presenter?.fetchImages()
    }
    
    func setupIndicatorView() {
        indicatorView.color = .systemMint
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
    }
    
    func addViews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(indicatorView)
    }
    
    func setupConstraints() {
        [searchBar, collectionView, indicatorView].forEach { 
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: margins.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
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
        if searchBar.text == nil && searchBar.text == "" {
            presenter?.tools.query = nil
            presenter?.clearSearch()
            collectionView.reloadData()
        }
        guard let query = searchBar.text?.lowercased(), query.trimmingCharacters(in: .whitespaces) != "", query.count > 2 else {
            return
        }
        presenter?.tools.query = query
        presenter?.fetchImages()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        indicatorView.startAnimating()
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
        indicatorView.stopAnimating()
        guard let newIndexPathsToReload else {
            collectionView.isHidden = false
            collectionView.reloadData()
            return
        }
        if let layout = self.collectionView.collectionViewLayout as? CustomLayout {
            layout.reloadData()
        }
        collectionView.insertItems(at: newIndexPathsToReload)
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
    
    func isLoadingLastCells(for indexPath: IndexPath) -> Bool {
        guard let currentCount = presenter?.currentCount else {
            return false
        }
        let lastCellsIndex = currentCount - 10
        return indexPath.item >= lastCellsIndex
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: UICollectionViewDataSource
extension SearchResultsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.currentCount ?? 0
    }
    
    /// - Tag: CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter else {
            fatalError("Presenter error")
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultsViewControllerCell.reuseID,
            for: indexPath) as? SearchResultsViewControllerCell else {
            fatalError("Expected `\(SearchResultsViewControllerCell.self)` type for reuseIdentifier \(SearchResultsViewControllerCell.reuseID). Check the configuration.")
        }
        let image = presenter.image(for: indexPath)
        cell.configure(for: image)
        return cell
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension SearchResultsVC: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingLastCells) {
            presenter?.fetchImages()
        }
    }
    
    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        
    }
    
}
