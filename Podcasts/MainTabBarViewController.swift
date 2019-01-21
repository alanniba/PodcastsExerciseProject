//
//  MainTabBarViewController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/3.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
        setUpPlayerDetailView()
        
//        perform(#selector(maxmizePlayerDetailView), with: nil, afterDelay: 1)
    }
    
    @objc func minimizePlayerDetailView(){
        maximizedTopAnhcorConstraint.isActive = false
        bottomAnhcorConstraint.constant = view.frame.height

        minimizedTopAnhcorConstraint.isActive = true

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.playerDetailView.maxmizeStackView.alpha = 0
            self.playerDetailView.minimizedView.alpha = 1
            self.tabBar.transform = .identity

        })

    }
    
    func maxmizePlayerDetailView(episode : Episode? , playListEpisode : [Episode] = []){
        minimizedTopAnhcorConstraint.isActive = false
        maximizedTopAnhcorConstraint.isActive = true
        maximizedTopAnhcorConstraint.constant = 0
        bottomAnhcorConstraint.constant = 0
        if episode != nil {
            playerDetailView.playerDetial = episode
        }
        playerDetailView.playListEpisode = playListEpisode
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailView.maxmizeStackView.alpha = 1
            self.playerDetailView.minimizedView.alpha = 0
        })



    }
    
    var maximizedTopAnhcorConstraint : NSLayoutConstraint!
    var minimizedTopAnhcorConstraint : NSLayoutConstraint!
    var bottomAnhcorConstraint : NSLayoutConstraint!
    let playerDetailView = PlayerDetialView.initFromNib()

    fileprivate func setUpPlayerDetailView(){
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnhcorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnhcorConstraint.isActive = true
        
        bottomAnhcorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant : view.frame.height)
        bottomAnhcorConstraint.isActive = true

        
        minimizedTopAnhcorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        

    }
    
    // MARK: - setup function
    fileprivate func setUpTabBar (){
        tabBar.tintColor = UIColor.purple
        let layout = UICollectionViewFlowLayout()

        let favoriteController = FavoriteController(collectionViewLayout: layout)

        viewControllers = [
            
            generateViewcontroller(with: favoriteController, title: "Favorites", image: "favorites"),
            generateViewcontroller(with: PodcastsSearchController(), title: "Search", image: "search"),
            generateViewcontroller(with: DownloadController(), title: "Downloads", image: "downloads")
        ]
    }
    
    // MARK: - helper functions
    fileprivate func generateViewcontroller (with  rootViewController : UIViewController ,title:String , image: String ) ->UIViewController {
        let generateController = UINavigationController(rootViewController: rootViewController)
        generateController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        generateController.tabBarItem.title = title
        generateController.tabBarItem.image = UIImage(named: image)
        return generateController
    }
    


}
