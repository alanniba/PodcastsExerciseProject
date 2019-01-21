//
//  PlayerDetialView.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/7.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage
import MediaPlayer
class PlayerDetialView: UIView {
    
    
    var playerDetial : Episode!{
        didSet{
            self.playerTitle.text = playerDetial.title
            self.artistLab.text = playerDetial.artist
            self.miniPlayerEpisodeTitleLab.text = playerDetial.title
            let imageUrl = URL(string: playerDetial.imageUrl ?? "")
            self.playerImage.sd_setImage(with: imageUrl)
            self.miniPlayerImageView.sd_setImage(with: imageUrl) { (image, _, _, _) in
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                guard let image = image else {return}
                
                let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                    return image
                })
                
                nowPlayingInfo?[MPMediaItemPropertyArtist] = artwork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            
            
            handlePlay()
            setupNowPlayingInfo()
        }
    }
    fileprivate func setupNowPlayingInfo(){
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = playerDetial.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = playerDetial.artist
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    fileprivate func observeCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] (time) in
            self?.currentTime.text = time.toReadableTime()
            self?.totalTime.text = self?.player.currentItem?.duration.toReadableTime()
            self?.updateCurrentTimeSlider()
            
//            self?.setupLockScreenCurrentTime()
        }
    }
    
//    fileprivate func setupLockScreenCurrentTime(){
//        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
//
//        guard let currentItem = player.currentItem else {return}
//
//        let duration = CMTimeGetSeconds(currentItem.duration)
//
//        let elapsed = CMTimeGetSeconds(player.currentTime())
//        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed
//        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = duration
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//    }
    
    func updateCurrentTimeSlider (){
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let persentage = Float(currentTime/duration)
        timeSlider.value = persentage
    }
    
    var panGesture : UIPanGestureRecognizer!
    fileprivate func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target:self, action:  #selector(handleMaxmize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        minimizedView.addGestureRecognizer(panGesture)
        
        
        maxmizeStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMaxStackView)))
    }
    

    
    @objc func handlePan(gesture:UIPanGestureRecognizer){
        if gesture.state == .began{
        } else if gesture.state == .changed{
            handleGestureChange(gesture: gesture)
        } else if gesture.state == .ended{
            handleGestureEnd(gesture: gesture)
        }
    }

    
    fileprivate func observeBoundryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {[weak self] in
            self?.playerImageAnimation()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration(){
        guard let playerDuration = player.currentItem?.duration else {return}
        
        let second = CMTimeGetSeconds(playerDuration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = second
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGesture()
        
        observeCurrentTime()

        observeBoundryTime()
        setupAudioSession()
        setupRemoteControl()
    }
    
    
    fileprivate func setupAudioSession (){
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

        } catch let error{
            print("Failed to active session",error)
        }
    }
    
    fileprivate func setupRemoteControl(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            let image = UIImage(named: "pause")
            self.playerBuy.setImage(image, for: .normal)
            self.miniPlayerPurseBut.setImage(image, for: .normal)
            self.setupElapsedTime()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            let image = UIImage(named: "play")
            self.playerBuy.setImage(image, for: .normal)
            self.miniPlayerPurseBut.setImage(image, for: .normal)
            self.setupElapsedTime()

            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousTrack))
    }
    
    var playListEpisode =  [Episode]()
    @objc fileprivate func handleNextTrack(){
        if playListEpisode.count == 0 {return}
        let currentIndex = playListEpisode.firstIndex{ (ep) -> Bool in
            return self.playerDetial.title == ep.title
        }
        guard let index = currentIndex else {return}
        
        let nextEpisode : Episode
        if index == playListEpisode.count - 1{
            nextEpisode = playListEpisode[0]
        } else {
             nextEpisode = playListEpisode[index + 1]
        }
        self.playerDetial = nextEpisode
        
    }
    
    @objc fileprivate func handlePreviousTrack(){
        if playListEpisode.count == 0 {return}
        let currentIndex = playListEpisode.firstIndex { (ep) -> Bool in
            return self.playerDetial.title == ep.title
        }
        guard let index = currentIndex else {return}
        let previousEpisode : Episode
        if index == 0{
            previousEpisode = playListEpisode[playListEpisode.count - 1]
        } else {
            previousEpisode = playListEpisode[index - 1]
        }
        self.playerDetial = previousEpisode
    }
    
    fileprivate func setupElapsedTime(){
        let elapseTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapseTime
        
        
    }
    
    
    

    
    //MARK:- outlet and action

    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var miniPlayerImageView: UIImageView!
    @IBOutlet weak var miniPlayerEpisodeTitleLab: UILabel!
    @IBOutlet weak var miniPlayerPurseBut: UIButton!{
        didSet{
            miniPlayerPurseBut.imageView?.contentMode = .scaleAspectFit

            miniPlayerPurseBut.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }

    @IBOutlet weak var miniPlayerFastBut: UIButton!{
        didSet{
            miniPlayerFastBut.imageView?.contentMode = .scaleAspectFit

            miniPlayerFastBut.addTarget(self, action: #selector(handleFast(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var minimizedView: UIView!
    @IBOutlet weak var maxmizeStackView: UIStackView!
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let persentage = timeSlider.value
        guard let duration = player.currentItem?.duration  else {return}
        let durationInSecond = CMTimeGetSeconds(duration)
        let seekTimeInSecond = Float64(persentage) * durationInSecond
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSecond, preferredTimescale: Int32(NSEC_PER_SEC))
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSecond
        player.seek(to: seekTime)
    }
    @IBAction func handleRewind(_ sender: Any) {
        seekCurrentTime(time: -15)
    }
    fileprivate func seekCurrentTime(time : Int64) {
        let fifteenSecond = CMTimeMake(value: time, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSecond)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleFast(_ sender: Any) {
        seekCurrentTime(time: 15)
    }
    @IBAction func handleVolume(_ sender: Any) {
        let persend = volumeSlider.value
        player.volume = persend
    }
    
    
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    fileprivate func playerImageAnimation(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.playerImage.transform = .identity
        })
    }
    
    fileprivate func playerImageAnimationSmall(){
        UIView.animate(withDuration: 0.5) {
            self.playerImage.transform = self.shrunkenTransform
        }
    }
    
    
    @IBOutlet weak var dismissBut: UIButton!
    @IBOutlet weak var playerImage: UIImageView!{
        didSet{
            
            playerImage.layer.cornerRadius = 5
            playerImage.clipsToBounds = true
            playerImage.transform = self.shrunkenTransform
        }
    }
    @IBOutlet weak var playerTitle: UILabel!
    @IBOutlet weak var artistLab: UILabel!
    @IBOutlet weak var playerBuy: UIButton!{
        didSet{
            let image = UIImage(named: "pause")
            playerBuy.setImage(image, for: .normal)
            playerBuy.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused{
            let image = UIImage(named: "pause")
            playerBuy.setImage(image, for: .normal)
            miniPlayerPurseBut.setImage(image, for: .normal)
            player.play()
            playerImageAnimation()
        } else {
            let image = UIImage(named: "play")
            playerBuy.setImage(image, for: .normal)
            miniPlayerPurseBut.setImage(image, for: .normal)
            player.pause()
            playerImageAnimationSmall()
        }
    }
    
    
    fileprivate func handlePlay(){
        if playerDetial.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            guard let url = URL(string: playerDetial.playUrl) else {return}
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }

        

    }
    
    fileprivate func playEpisodeUsingFileUrl(){
        print("attempt to play episode with file url", playerDetial.fileUrl ?? "")
        
        //figure out the file name for our episode file url
        guard let fileUrl = URL(string: playerDetial.fileUrl ?? "") else {return}
        let fileName = fileUrl.lastPathComponent
        guard var trueLocation  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        trueLocation.appendPathComponent(fileName)
        
        print("true location of episode :" , trueLocation.absoluteString)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    static func initFromNib() -> PlayerDetialView {
        return Bundle.main.loadNibNamed("PlayerDetialView", owner: self, options: nil)?.first as! PlayerDetialView
    }
    
}
