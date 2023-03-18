//
//  TabbarViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTabbarItem()
        setTabbarItem()
    }
}

// MARK: - Helpers
private extension TabbarViewController {
    
    func addTabbarItem() {
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), tag: 0)
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 1)
        viewControllers = [homeViewController, searchViewController]
    }
    
    func setTabbarItem() {
        self.tabBar.tintColor = .black
    }
}
