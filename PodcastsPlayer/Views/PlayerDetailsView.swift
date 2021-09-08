//
//  PlayerDetailsView.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 08.09.2021.
//

import UIKit


class PlayerDetailsView: UIView {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func dismissButton(_ sender: UIButton) {
        self.isHidden = true
    }
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
