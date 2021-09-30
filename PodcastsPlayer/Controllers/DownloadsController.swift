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
        setupObservers()
    }
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downldProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else {return}
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else {return}
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        print("123")
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        print(userInfo)
        guard let progress = userInfo["progress"] as? Double else {return}
        guard let title = userInfo["title"] as? String else {return}
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else {return}
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else {return}
        cell.percentLabel.isHidden = false
        cell.imageLabel.alpha = 0.5
        cell.percentLabel.text = "\(Int(progress * 100))%"
        if progress == 1 {
            cell.percentLabel.isHidden = true
            cell.imageLabel.alpha = 1
        }
        print(progress,title)
    }
    func showSadgeHightLightDownload() {
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    //MARK:- setups
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
       
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title:"Yes", style: .default, handler: { _ in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteEpisode(episode: episode)
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
