//
//  PodcastsSearchController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 04.09.2021.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate{
    var podcasts = [Podcast(trackName: "How do this App", artistName: "Stas"),
                    Podcast(trackName: "How work with Flow", artistName: "Katya")]
    
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let freedSpaceString = searchText.filter {!$0.isWhitespace}
        let url = "https://itunes.apple.com/search?term=\(freedSpaceString)"
        AF.request(url).responseData { dataResponse in
            if let err = dataResponse.error {
                print("Error", err)
                return
            }
            guard let data = dataResponse.data else {return}
            do {
            let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                self.podcasts = searchResult.results
                self.tableView.reloadData()
            } catch let decodeError {
                print("error: ", decodeError)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(podcasts[indexPath.row].trackName ?? "") \n \(podcasts[indexPath.row].artistName ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
}
