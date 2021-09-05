//
//  Podcasts.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 04.09.2021.
//

import UIKit

struct Podcast {
    var name: String
    var artistName: String
}

// MARK: - Welcome
struct Welcome: Decodable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Decodable {
    let artistID, collectionID: Int?
    let trackID: Int
    let artistName: String
    let collectionName: String?
    let trackName: String
    let collectionCensoredName: String?
    let trackCensoredName: String
    let artistViewURL, collectionViewURL: String?
    let trackViewURL: String
    let previewURL: String
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice, trackPrice: Double
    let releaseDate: Date

}
