//
//  EpisodeTableViewController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/5.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import FeedKit
class EpisodeTableViewController: UITableViewController {
    var podcast : Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
            fetchEpisode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupNavigationBarButtons()
    }
    
    fileprivate func setupNavigationBarButtons(){
        
        let savedPodcast = UserDefaults.standard.getSavedPodcast()
        let hasFavorite = savedPodcast.index(where : { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName }) != nil
        if  hasFavorite{
            let heartImage = UIImage(named: "heardIcon")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: nil)
          
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))            ]
        }
        

    }
    
    @objc fileprivate func handleSaveFavorite(){
        guard let podcast = self.podcast else {return}
        var listOfPodcast = UserDefaults.standard.getSavedPodcast()
        listOfPodcast.append(podcast)
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
            let heartImage = UIImage(named: "heardIcon")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: nil)

        } catch let error{
            print("unable to transite object to data ", error)
        }
        
        showBadgeHighlight()
    }
    
    @objc fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBar().viewControllers?[0].tabBarItem.badgeValue = "new"
    }
    
    @objc fileprivate func handleFetchSavePodcasts(){
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else {return}
        do{
            let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
            savedPodcasts?.forEach({ (p) in
            })
        } catch let error{
            print(error)
        }
        
    }
    
    var episodes = [Episode]()
    
    //MARK:- fetch Data
    fileprivate func fetchEpisode(){
        guard let feedUrl = podcast?.feedUrl else {
            print("feed url is not availible")
            return
        }
        APISerivec.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    
    //MARK:- Table view setup
    func tableViewSetup (){
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- Table view delegate
    fileprivate let cellId = "cellId"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeTableViewCell
        
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.startAnimating()
        return activityIndicator
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return episodes.count > 0 ? 0 : 200
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainTabBarVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarViewController
        let episode = self.episodes[indexPath.row]

        mainTabBarVC.maxmizePlayerDetailView(episode: episode, playListEpisode: self.episodes)
  }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadedEpisode = UserDefaults.standard.getDownloadEpisode()

        let hasDownload = downloadedEpisode.index(where:{ $0.title == self.episodes[indexPath.row].title}) != nil
        if !hasDownload{
            let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
                print("download")
                UserDefaults.standard.downloadEpidose(episode: self.episodes[indexPath.row])
                UIApplication.mainTabBar().viewControllers?[2].tabBarItem.badgeValue = "new"
                
                //download podcast episode using alamofire
                APISerivec.shared.downloadEpisode(episode: self.episodes[indexPath.row])
            }
            return [downloadAction]
        } else {
            let downloaded = UITableViewRowAction(style: .normal, title: "downloaded") { (_, _) in
                
            }
            return [downloaded]
        }
        
    }

    
    
}
