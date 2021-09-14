//
//  MainTabBarController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 03.09.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    var minimalAnchorConstraints: NSLayoutConstraint!
    var maximalAnchorConstraints: NSLayoutConstraint!
    let playerDetailsView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewController()
        setupPlayerDetailsView()
    }
    @objc func minimizePlayerDetails() {
        maximalAnchorConstraints.isActive = false
        minimalAnchorConstraints.isActive = true
        playerDetailsView.miniPlayerView.isHidden = false
        playerDetailsView.maximizedStackView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
        }
       
    }
     func maximizePlayerDetails(episode: Episode?) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        maximalAnchorConstraints.isActive = true
        maximalAnchorConstraints.constant = 0
        minimalAnchorConstraints.isActive = false
        playerDetailsView.miniPlayerView.isHidden = true
        playerDetailsView.maximizedStackView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = true
        }
    }
//MARK: - Setup Functions
    fileprivate func setupPlayerDetailsView() {
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
//        view.addSubview(playerDetailsView)
       // playerDetailsView.frame = view.frame
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximalAnchorConstraints = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximalAnchorConstraints.isActive = true
        minimalAnchorConstraints = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimalAnchorConstraints.isActive = true
        
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func setupViewController() {
        viewControllers = [generationnavigationController(with: PodcastsSearchController(),
                                                          image: UIImage(named: "search")!,
                                                          title: "Search"),
                           generationnavigationController(with: ViewController(),
                                                          image: UIImage(named: "favorites")!,
                                                          title: "Favorites"),
                           generationnavigationController(with: ViewController(),
                                                          image: UIImage(named: "downloads")!,
                                                          title: "Downloads")]
    }
//MARK: - Helper Functions
   fileprivate func generationnavigationController(with rootViewController: UIViewController,
                                                   image: UIImage,
                                                   title: String) -> UIViewController {
    let navigationViewController = UINavigationController(rootViewController: rootViewController)
    rootViewController.title = title
    navigationViewController.tabBarItem.title = title
    navigationViewController.tabBarItem.image = image
    return navigationViewController
    }
}
