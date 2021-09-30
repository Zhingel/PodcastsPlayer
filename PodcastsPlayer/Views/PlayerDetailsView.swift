//
//  PlayerDetailsView.swift
//  PodcastsPlayer
//
//  Created by Стас Жингель on 08.09.2021.
//

import UIKit
import AVKit
import MediaPlayer
import SDWebImage

class PlayerDetailsView: UIView {
    var episode: Episode! {
        didSet {
            authorLabel.text = episode.author
            titleLabel.text = episode.title
            episodeTitleMiniPlayer.text = episode.title
            let url = URL(string: episode.imageUrl ?? "")
            imageLabel.sd_setImage(with: url)
            appIconMiniPlayer.sd_setImage(with: url) { image,_,_,_ in
                guard let image = image else {return}
                var nowPlayingInfo =  MPNowPlayingInfoCenter.default().nowPlayingInfo
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            setupNowPlayingInfo()
            playEpisode()
        }
    }
    var playlistEpisodes = [Episode]()
    func setupNowPlayingInfo() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
         
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    func playEpisode(){
        if episode.fileUrl != nil {
            guard let fileURL = URL(string: episode.fileUrl ?? "") else {return}
            let fileName = fileURL.lastPathComponent
            guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            trueLocation.appendPathComponent(fileName)
            print(trueLocation.absoluteString)
            let playerItem = AVPlayerItem(url: trueLocation)
            player.replaceCurrentItem(with: playerItem)
 
        } else {
            guard let url = URL(string: episode.streemUrl) else {return}
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)

        }
    }
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durratinLabel.text = durationTime?.toDisplayString()
            self?.currentTimeSlider.maximumValue = 1
            self?.currentTimeSlider.value = Float(CMTimeGetSeconds(time))/Float(CMTimeGetSeconds(durationTime ?? CMTimeMake(value: 1, timescale: 1)))
        }
    }

    fileprivate func observerBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.inLargeEpisodeImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRemoteControl()
        setupAudioSession()
        setupGestures()
        observePlayerCurrentTime()
        observerBoundaryTime()
        
    }
    //MARK: - Playback functions
    func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.playButtonminiPlayer.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.playButtonminiPlayer.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.playPause()
            return .success
        }
        
       // commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
    }
    
    @objc func handleNextTrack() {
       
        if playlistEpisodes.count == 0 {
            return
        }
        let currentEpisodeIndex = playlistEpisodes.firstIndex {(ep) -> Bool in
            return self.episode.title == ep.title && self.episode.author == ep.author
        }
        guard let index = currentEpisodeIndex else {return}
        let nextEpisode: Episode
        if index == playlistEpisodes.count - 1 {
             nextEpisode = playlistEpisodes[0]
        } else {
        nextEpisode = playlistEpisodes[index + 1]
        }
        self.episode = nextEpisode
    }
    fileprivate func setupElapsedTime() {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        } 
    }
    //MARK: - Drag and drop animation functins
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.maximizedStackView.transform = .identity
                if translation.y > 50  {
                    let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController
                    mainTabBarController?.minimizePlayerDetails()
                }
            }
        }
    }
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y/200
        self.maximizedStackView.alpha = -translation.y/200
    }
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController
                mainTabBarController?.maximizePlayerDetails(episode: nil)
            } else {
            self.miniPlayerView.alpha = 1
            self.maximizedStackView.alpha = 0
            }
        }
    }
    @objc func handleTapMaximize() {
        let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: nil)
    }
    
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
            playButtonminiPlayer.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            inLargeEpisodeImageView()
        } else {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playButtonminiPlayer.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
 
    
    
    //MARK: - Animations image
    
    func inLargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageLabel.transform = .identity
        }, completion: nil)
    }
    func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: nil)
    }
     
   
    
    //MARK: - Outlets and Actions
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var imageLabel: UIImageView! {
        didSet {
            let scale: CGFloat  = 0.7
            imageLabel.layer.cornerRadius = 5
            imageLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durratinLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBAction func actionCurrentTime(_ sender: UISlider) {
        player.seek(to: CMTimeMakeWithSeconds(Float64(currentTimeSlider.value * Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))), preferredTimescale: Int32(NSEC_PER_SEC)))
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeMakeWithSeconds(Float64(currentTimeSlider.value * Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))), preferredTimescale: Int32(NSEC_PER_SEC))
    }
    @IBAction func timeChangeRewind(_ sender: UIButton) {
        player.seek(to: CMTimeMakeWithSeconds(Float64(currentTimeSlider.value * Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))) - 15, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    @IBAction func timeChangeForward(_ sender: UIButton) {
        player.seek(to: CMTimeMakeWithSeconds(Float64(currentTimeSlider.value * Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))) + 15, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    @IBAction func volumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    @IBAction func dismissButton(_ sender: UIButton) {
        let minimize = UIApplication.shared.windows[0].rootViewController as? MainTabBarController
        minimize?.minimizePlayerDetails()
    
     }
    @IBOutlet weak var authorLabel: UILabel!
    

    //MARK: - MiniPlayer Outlets and Actions
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var episodeTitleMiniPlayer: UILabel!
    @IBOutlet weak var appIconMiniPlayer: UIImageView!
    @IBOutlet weak var playButtonminiPlayer: UIButton! {
        didSet {
            playButtonminiPlayer.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        }
    }
    @IBAction func forwardButtonMiniPlayer(_ sender: Any) {
        player.seek(to: CMTimeMakeWithSeconds(Float64(currentTimeSlider.value * Float(CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)))) + 15, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
}

