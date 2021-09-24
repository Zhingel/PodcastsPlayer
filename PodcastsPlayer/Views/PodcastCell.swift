//
//  PodcastCell.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 05.09.2021.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            guard let url = URL(string: podcast.artworkUrl100 ?? "") else {return}
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
