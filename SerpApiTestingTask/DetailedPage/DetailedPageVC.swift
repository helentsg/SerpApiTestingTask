//
//  DetailedVC.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 12.03.2024.
//

import UIKit

protocol DetailedPageViewProtocol: AnyObject {
    func set(pages: [UIViewController])
}

class DetailedPageVC: UIPageViewController {
    
    private var previousButton = UIBarButtonItem()
    private var nextButton: UIBarButtonItem?
   
    var presenter: DetailedPagePresenterProtocol?
    
    // MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.createInitialPage()
    }
    
    func setupViews() {
        setupSelf()
        setupNavigationController()
    }
    
    func setupSelf() {
        delegate = self
        dataSource = self
    }

    func setupNavigationController() {
        let backBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(close))
        navigationItem.backBarButtonItem = backBarButtonItem
        previousButton = UIBarButtonItem(title: "Prev",
                                         style: .done,
                                         target: self,
                                         action: #selector(showPreviousImage))
        
        let buttons = [backBarButtonItem, previousButton]
        navigationItem.leftBarButtonItems = buttons
        
        nextButton = UIBarButtonItem(title: "Next",
                                     style: .done,
                                     target: self,
                                     action: #selector(showNextImage))
        navigationItem.rightBarButtonItem = nextButton
        
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        presenter?.navigateBackToList()
    }
    
    @IBAction func showPreviousImage(_ sender: UIBarButtonItem) {
        presenter?.previousButtonTapped()
    }
    
    @IBAction func showNextImage(_ sender: UIBarButtonItem) {
        presenter?.nextButtonTapped()
    }
    
}

// MARK: UIPageViewControllerDataSource
extension DetailedPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        presenter?.getPreviousVC()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        presenter?.getNextVC()
    }
    
}

// MARK: UIPageViewControllerDataSource
extension DetailedPageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
}

// MARK: ToolListViewInputProtocol
extension DetailedPageVC: DetailedPageViewProtocol {
    
    func set(pages: [UIViewController]) {
        setViewControllers(pages, direction: .forward, animated: false)
    }
    
    func configure(for image: ImagesResult) {
        
        if image.position == 0 {
            previousButton.isEnabled = false
        }
    }
    
}
