//
//  Episode.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 06.09.2021.
//

import Foundation
import FeedKit
struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
    }
}
