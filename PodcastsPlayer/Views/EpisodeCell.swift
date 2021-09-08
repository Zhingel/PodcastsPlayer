//
//  EpisodeCell.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 06.09.2021.
//

import UIKit

class EpisodeCell: UITableViewCell {
    var episode: Episode! {
        didSet {
           titleLabel.text = episode.title
           descriptionLabel.text = episode.description
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MMM dd, yyyy"
           dateLabel.text = dateFormater.string(from: episode.pubDate)
            let url = URL(string: episode.imageUrl ?? "")
            imageLabel.sd_setImage(with: url)
        }
    }
 
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var imageLabel: UIImageView!
}
