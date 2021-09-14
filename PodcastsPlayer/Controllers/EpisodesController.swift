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
    }
    
    
    
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
        mainTabBarController?.maximizePlayerDetails(episode: episode)
      
        
//        let episode = self.episodes[indexPath.row]
     //   let playerDetailsView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
     //   let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
      //  playerDetailsView.frame = view.frame
    //    playerDetailsView.episode = episode
//        window?.addSubview(playerDetailsView)
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
