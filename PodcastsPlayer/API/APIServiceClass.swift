//
//  APIServiceClass.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 05.09.2021.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let downldProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    static let shared = APIService()
    func fetchPodcasts(searchText: String, compilitionHendler: @escaping ([Podcast]) -> ()) {
        let freedSpaceString = searchText.filter {!$0.isWhitespace}
        var url = "https://itunes.apple.com/search?term=\(freedSpaceString)&country=ru&entity=podcast"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
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
          //  print(progress.fractionCompleted)

            NotificationCenter.default.post(name: .downldProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            
        }.response { resp in
          //  print("gggggg \(resp.fileURL?.absoluteString ?? "")")
            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(resp.fileURL?.absoluteString ?? "" , episode.title)
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete)
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
