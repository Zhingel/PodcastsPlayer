//
//  FavoritesController.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 25.09.2021.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var podcasts = UserDefaults.standard.savedPodcasts()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    fileprivate let cellId = "cellId"
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoritesPodcastCell.self, forCellWithReuseIdentifier: cellId)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location =  gesture.location(in: collectionView)
        guard let selectedIndex = collectionView.indexPathForItem(at: location) else {return}
        print(selectedIndex .item)
        let alertController = UIAlertController(title: "Remove Podcast", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { _ in
            self.collectionView.deleteItems(at: [selectedIndex])
            self.podcasts.remove(at: selectedIndex.item)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    //MARK: - line spacing and delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId , for: indexPath) as! FavoritesPodcastCell
        cell.podcast = self.podcasts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16)/2
        return CGSize(width: width, height: width + 46)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
