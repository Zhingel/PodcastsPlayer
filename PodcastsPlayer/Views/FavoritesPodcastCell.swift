//
//  FavoritesPodcastCell.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 25.09.2021.
//

import UIKit
import SDWebImage

class FavoritesPodcastCell: UICollectionViewCell {
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            let url = URL(string: podcast.artworkUrl100 ?? "" )
            imageView.sd_setImage(with: url)
        }
    }
    let imageView = UIImageView(image: UIImage(named: "appicon"))
    let nameLabel = UILabel()
    let artistNameLabel = UILabel()
    fileprivate func stylizeUI() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        nameLabel.text = "Podcast layout"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.text = "artist layout"
        artistNameLabel.font = UIFont.systemFont(ofSize: 14)
        artistNameLabel.textColor = .lightGray
    }
    
    fileprivate func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel,artistNameLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylizeUI()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
