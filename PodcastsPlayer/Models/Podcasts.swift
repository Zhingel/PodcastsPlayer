//
//  Podcasts.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 04.09.2021.
//

import UIKit

class Podcast: NSObject, Decodable, NSCoding {
    func encode(with coder: NSCoder) {
        print("transform podcast into data")
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName  ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl100 ?? "", forKey: "artworkURLNameKey")
    }
    
    required init?(coder: NSCoder) {
        print("trying to turn data into Podcast")
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl100 = coder.decodeObject(forKey: "artworkURLNameKey") as? String
    }
    
    var trackName: String?
    var artistName: String?
    var artworkUrl100: String?
    var trackCount: Int?
    var feedUrl: String?
}

// MARK: - Welcome
struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

