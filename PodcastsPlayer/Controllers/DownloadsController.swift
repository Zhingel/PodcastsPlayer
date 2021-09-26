//
//  DownloadsController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 26.09.2021.
//

import UIKit

class DownloadsController: UITableViewController {
    var episodes = UserDefaults.standard.downloadedEpisodes()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
    }
    //MARK:- setups
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: self.episodes[indexPath.row], playlistEpisodes: self.episodes)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
