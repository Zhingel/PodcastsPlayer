//
//  MainTabBarController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 03.09.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewController()
    }
    
    
    
    
    
    
//MARK: - Setup Functions
    func setupViewController() {
        viewControllers = [generationnavigationController(with: PodcastsSearchController(), image: UIImage(named: "search")!, title: "Search"),
                           generationnavigationController(with: ViewController(), image: UIImage(named: "favorites")! , title: "Favorites"),
                           generationnavigationController(with: ViewController(), image: UIImage(named: "downloads")!, title: "Downloads")]
    }
    
    
    
//MARK: - Helper Functions
    
   fileprivate func generationnavigationController(with rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
    rootViewController.title = title
    navigationViewController.tabBarItem.title = title
    navigationViewController.tabBarItem.image = image
    return navigationViewController
    }
}
