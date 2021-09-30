//
//  Episode.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 06.09.2021.
//

import Foundation
import FeedKit
struct Episode: Codable {
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let streemUrl: String
    var imageUrl: String?
    var fileUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.streemUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
