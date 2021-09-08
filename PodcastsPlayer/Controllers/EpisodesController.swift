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
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let playerDetailsView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        playerDetailsView.frame = view.frame
        playerDetailsView.titleLabel.text = episode.title
        let url = URL(string: episode.imageUrl ?? "")
        playerDetailsView.imageLabel.sd_setImage(with: url)
        window?.addSubview(playerDetailsView)
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
