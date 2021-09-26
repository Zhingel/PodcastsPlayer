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
        let url = "https://itunes.apple.com/search?term=\(freedSpaceString)&country=ru&entity=podcast"
        AF.request(url).responseData { dataResponse in
            if let err = dataResponse.error {
                print("Errr", err)
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
    func downloadEpisode(episode: Episode) {
        print("загрузка", episode.streemUrl)
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.streemUrl, to: downloadRequest).downloadProgress { progress in
            print(progress.fractionCompleted)
        }.response { resp in
//            print(resp.destinationURL?.absoluteString ?? "")
//            let downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
//            downloadedEpisodes.index(where: ($0. == episode.title))
        }
        
    }
}
