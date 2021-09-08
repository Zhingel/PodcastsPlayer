//
//  PlayerDetailsView.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 08.09.2021.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    var episode: Episode! {
        didSet {
            authorLabel.text = episode.author
            titleLabel.text = episode.title
            let url = URL(string: episode.imageUrl ?? "")
            imageLabel.sd_setImage(with: url)
            playEpisode()
        }
    }
    func playEpisode(){
        guard let url = URL(string: episode.streemUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playButton.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        }
    }
    @objc func playPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    @IBAction func dismissButton(_ sender: UIButton) {
      //  self.isHidden = true
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageLabel.transform = .identity
        }, completion: nil)
    }
    @IBOutlet weak var imageLabel: UIImageView! {
        didSet {
            let scale: CGFloat  = 0.7
            imageLabel.layer.cornerRadius = 5
            imageLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
}
