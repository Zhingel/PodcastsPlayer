//
//  Userdefoults.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 26.09.2021.
//

import Foundation

extension UserDefaults {
    static let favoritesPodcastKey = "favoritesPodcastKey"
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritesPodcastKey) else {return []}
        guard let savedPodcast = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastData) as? [Podcast] else {return []}
        return savedPodcast
    }
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritesPodcastKey)
    }
}
