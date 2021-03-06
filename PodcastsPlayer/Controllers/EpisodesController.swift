//
//  EpisodesController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 06.09.2021.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    var episodes = [Episode]()
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        setupNavigationBarButtons()
    }
    
    fileprivate func setupNavigationBarButtons() {
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorites: Bool = savedPodcasts.firstIndex(where: {$0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
        if hasFavorites  {
            let image = UIImage(systemName: "heart.fill")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(handleSaveFavorite)),
//                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
            ]
        }
       
    }
    @objc func handleFetchSavedPodcasts() {
        print("Fetch podcasts")
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritesPodcastKey) else {return}
        let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        savedPodcasts?.forEach({ p in
            print(p.trackName ?? "")
        })
    }
    
    @objc func handleSaveFavorite() {
        guard let podcast = self.podcast else {return}
        
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritesPodcastKey)
        }
        catch {
            print(error)
        }
        showSadgeHightLight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func showSadgeHightLight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let downloadAction = UIContextualAction(style: .normal, title: "Download") {  (_, _, _) in
              print("downloading episodes into UserDefaults")
              let episode = self.episodes[indexPath.row]
              UserDefaults.standard.downloadEpisode(episode: episode)
              APIService.shared.downloadEpisode(episode: episode)
              let download = DownloadsController()
              download.showSadgeHightLightDownload()
      }
      let swipeActions = UISwipeActionsConfiguration(actions: [downloadAction])

      return swipeActions
  }
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { _, _ in
//            print("downloading episodes into UserDefaults")
//            let episode = self.episodes[indexPath.row]
//            UserDefaults.standard.downloadEpisode(episode: episode)
//            APIService.shared.downloadEpisode(episode: episode)
//            let download = DownloadsController()
//            download.showSadgeHightLightDownload()
//        }
//        return [downloadAction]
//    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        if episodes.isEmpty {
            activityIndicatorView.startAnimating()
        }
        return activityIndicatorView
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let episode = self.episodes[indexPath.row]
        
        let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController
        let playerDetailsView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
        playerDetailsView.episode = episode
        mainTabBarController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        
      
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        
        return cell
    }
    
    //MARK: - Fetch episodes
    func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else {return}
        guard let url = URL(string: feedUrl) else {return}
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync(result: { result in
                switch result {
                case .success(let feed):
                    // Or alternatively...
                    switch feed {
                    case let .rss(feed):
                        let imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
                        var episodes = [Episode]()
                        feed.items?.forEach({ feedItem in
                            var episode = Episode(feedItem: feedItem)
                            if episode.imageUrl == nil {
                                episode.imageUrl = imageUrl
                            }
                            episodes.append(episode)
                        })
                        DispatchQueue.main.async {
                            self.episodes = episodes
                            self.tableView.reloadData()
                        }
                        break
                    default: print("error")
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
