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
    
}
