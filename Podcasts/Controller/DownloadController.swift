//
//  DownloadController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/26.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class DownloadController: UITableViewController {
    var downloadedEpisode = UserDefaults.standard.getDownloadEpisode()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadedEpisode = UserDefaults.standard.getDownloadEpisode()
        tableView.reloadData()
        UIApplication.mainTabBar().viewControllers?[2].tabBarItem.badgeValue = nil

    }
    
    fileprivate func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleDoanloadProgess), name: .downloadProgess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    
    @objc fileprivate func handleDownloadComplete(notification : Notification){
        guard let episodeDownloadComplete = notification.object as? APISerivec.EpisodeDownloadCompleteTuple else {
            return
        }
        guard let index = self.downloadedEpisode.index(where : {$0.title == episodeDownloadComplete.episodeTile}) else {return}
        self.downloadedEpisode[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    @objc fileprivate func handleDoanloadProgess(notification : Notification){
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        guard let progess = userInfo["progress"] as? Double else{return}
        guard let title = userInfo["title"] as? String else {return}
        print(progess, title)
        
        // find the index using title
        guard let index = self.downloadedEpisode.index(where : {$0.title == title}) else {return}
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeTableViewCell else {return}
        cell.progressLab.text = "\(Int(progess * 100))%"
        cell.progressLab.isHidden = false

        if progess == 1 {
            cell.progressLab.isHidden = true
        }
    }
    
    let cellID = "cellID"
    fileprivate func setupTableView(){
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeTableViewCell
        cell.selectionStyle = .none
        cell.episode = downloadedEpisode[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisode.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (_, _) in
            UserDefaults.standard.deleteDownloadEpisode(episode: self.downloadedEpisode[indexPath.row])
            self.downloadedEpisode.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.downloadedEpisode[indexPath.row]
       
        if episode.fileUrl != nil {
             UIApplication.mainTabBar().maxmizePlayerDetailView(episode: episode, playListEpisode: self.downloadedEpisode)
        } else{
            let alertController = UIAlertController(title: "unable to play locally", message: "using networt playing", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "yes", style: .default, handler: { (_) in
                UIApplication.mainTabBar().maxmizePlayerDetailView(episode: episode, playListEpisode: self.downloadedEpisode)
            }))
            alertController.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: { (_) in
                
            }))
            present(alertController, animated:  true  )
        }
    }
}
