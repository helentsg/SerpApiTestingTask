//
//  UIPageViewController+Extension.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 14.03.2024.
//

import UIKit

extension UIPageViewController {
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)?) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)?) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
}
