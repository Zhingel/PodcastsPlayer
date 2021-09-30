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
          //  print("gggggg \(resp.fileURL?.absoluteString ?? "")")
            var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.author == episode.author}) else {return}
            downloadedEpisodes[index].fileUrl = resp.fileURL?.absoluteString ?? ""
            print("downloadedFile ------//",downloadedEpisodes[index].fileUrl ?? "dont have file")
            do {
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
            } catch let err {
                print("Failed to encode ", err)
            }
          
        }
        
    }
}
