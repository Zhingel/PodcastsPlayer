//
//  EpisodesController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 06.09.2021.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    func fetchEpisodes() {
        print("Fetch episodes url and boobbobobobobobobobobo:",podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else {return}
        guard let url = URL(string: feedUrl) else {return}
        let parser = FeedParser(URL: url)
        parser.parseAsync(result: { result in
            print("successful print ololololoaoaoaoaoaoaoa", result)
            switch result {
            case .success(let feed):
                
                
                // Or alternatively...
                switch feed {
                case .atom(_): break       // Atom Syndication Format Feed Model
                case let .rss(feed):
                    var episodes = [Episode]()
                    feed.items?.forEach({ feedItem in
                        let episode = Episode(feedItem: feedItem)
                        episodes.append(episode)
                    })
                    DispatchQueue.main.async {
                        self.episodes = episodes
                        self.tableView.reloadData()
                    }
                    break
                    
                case .json(_): break       // JSON Feed Model
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
}
