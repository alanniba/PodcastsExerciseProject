//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/4.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController , UISearchBarDelegate{
    let cellID = "cellID"
    var podcasts = [Podcast]()
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super .viewDidLoad()
        setupSearchBar()
        setupTableView()
//        searchBar(searchController.searchBar, textDidChange: "voong")
    }
    

    
    
    //MARK: -set up functions
    fileprivate func setupSearchBar(){
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    

    //MARK: -searchBar APIresponse
    var timer : Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APISerivec.shared.fetchPodcasts(searchText: searchText) { (podCasts) in
                self.podcasts = podCasts
                self.tableView.reloadData()
            }
        })
    }
    

    
    //MARK:- table view works
    fileprivate func setupTableView(){
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.tableFooterView = UIView()
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        let podcasts = self.podcasts[indexPath.row]
        cell.podcast = podcasts
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lable = UILabel()
        lable.text = "Please enter a Search Term"
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lable
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeTableViewController = EpisodeTableViewController()
        let  podcast = self.podcasts[indexPath.row]
            episodeTableViewController.podcast = podcast
        
        navigationController?.pushViewController(episodeTableViewController, animated: true)
    }
}
