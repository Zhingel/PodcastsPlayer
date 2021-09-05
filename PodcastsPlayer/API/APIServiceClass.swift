//
//  APIServiceClass.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 05.09.2021.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    func fetchPodcasts(searchText: String, compilitionHendler: @escaping ([Podcast]) -> ()) {
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
                compilitionHendler(searchResult.results)
            } catch let decodeError {
                print("error: ", decodeError)
            }
        }
    }
}
