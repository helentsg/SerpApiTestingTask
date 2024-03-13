

import UIKit

protocol ToolListViewProtocol: AnyObject {
    func reloadList()
}

class ToolListVC: UIViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var clearBarItem: UIBarButtonItem!
    
    var presenter: ToolListPresenterProtocol?
    
    // MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.showList()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        presenter?.clearSelection()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        presenter?.close()
    }
    
}

// MARK: SetupViewProtocol
extension ToolListVC {
    
    func setupViews() {
        setupNavigationController()
        setupCloseButton()
        setupClearButton()
        setupSearchBar()
        setupTableView()
    }
    
    func setupNavigationController() {
        guard let presenter else { return }
        title = presenter.type.title
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemMint
    }
    
    func setupClearButton() {
        clearBarItem = UIBarButtonItem(title: "Clear",
                                       image: nil,
                                       target: self,
                                       action: #selector(clearButtonTapped))
        navigationItem.rightBarButtonItem = clearBarItem
    }
    
    func setupCloseButton() {
        let closeBarItem = UIBarButtonItem(title: "Close",
                                       image: nil,
                                       target: self,
                                       action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeBarItem
    }
    
    func setupSearchBar() {
        guard let presenter else { return }
        searchBar.placeholder = presenter.type.searchBarPlaceholder
        searchBar.delegate = self
    }
    
    func setupTableView() {
        tableView.register(ToolListCell.self, forCellReuseIdentifier: ToolListCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }

}

// MARK: UISearchBarDelegate
extension ToolListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        self.perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reload(searchBar)
    }
    
    @IBAction func reload(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            presenter?.query = nil
            presenter?.showList()
        }
        guard let query = searchBar.text?.lowercased(), query.trimmingCharacters(in: .whitespaces) != "", query.count > 2 else {
            return
        }
        presenter?.query = query
        presenter?.showList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ToolListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.listCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolListCell.reuseID, for: indexPath) as! ToolListCell
        let listData = presenter.listData(for: indexPath)
        cell.configure(for: listData)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ToolListCell else { return }
        cell.isSelected = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let presenter = self?.presenter else { return }
            presenter.selectedRow(for: indexPath)
        }
    }
    
}

// MARK: ToolListViewInputProtocol
extension ToolListVC: ToolListViewProtocol {
    
    func reloadList() {
        tableView.reloadData()
    }
    
}
