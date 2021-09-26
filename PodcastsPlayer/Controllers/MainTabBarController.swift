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
    var bottomAnchorConstraints: NSLayoutConstraint!
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
        bottomAnchorConstraints.constant = view.frame.height
        playerDetailsView.miniPlayerView.alpha = 1
        playerDetailsView.maximizedStackView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
        }
       
    }
    func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = []) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        playerDetailsView.playlistEpisodes = playlistEpisodes
        minimalAnchorConstraints.isActive = false
        maximalAnchorConstraints.isActive = true 
        maximalAnchorConstraints.constant = 0
        bottomAnchorConstraints.constant = 0
        playerDetailsView.miniPlayerView.alpha = 0
        playerDetailsView.maximizedStackView.alpha = 1
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
        bottomAnchorConstraints = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraints.isActive = true
        minimalAnchorConstraints = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimalAnchorConstraints.isActive = true
        
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    func setupViewController() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        viewControllers = [generationnavigationController(with: PodcastsSearchController(),
                                                          image: UIImage(named: "search")!,
                                                          title: "Search"),
                           generationnavigationController(with: favoritesController,
                                                          image: UIImage(named: "favorites")!,
                                                          title: "Favorites"),
                           generationnavigationController(with: DownloadsController(),
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
