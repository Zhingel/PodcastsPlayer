//
//  PodcastsSearchController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 04.09.2021.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate{
    var podcasts = [Podcast]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    //MARK:- TableViewSetUp
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib , forCellReuseIdentifier: "Cell")
    }
    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            APIService.shared.fetchPodcasts(searchText: searchText) { searchResult in
                        self.podcasts = searchResult
                        self.tableView.reloadData()
            }
        })
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a search term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .purple
        return label
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PodcastCell
        cell.artistNameLabel.text = podcasts[indexPath.row].artistName ?? ""
        cell.trackNameLabel.text = podcasts[indexPath.row].trackName ?? ""
        cell.episodeCountLabel.text = "\(podcasts[indexPath.row].trackCount ?? 0) episodes"
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
//MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        navigationController?.pushViewController(episodesController, animated: true)
        episodesController.podcast = podcasts[indexPath.row]
    }
}
