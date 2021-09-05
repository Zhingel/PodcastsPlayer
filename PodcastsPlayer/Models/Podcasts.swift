//
//  Podcasts.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 04.09.2021.
//

import UIKit

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
}

// MARK: - Welcome
struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

