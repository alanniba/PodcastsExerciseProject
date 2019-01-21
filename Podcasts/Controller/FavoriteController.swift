//
//  FavoriteController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/21.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class FavoriteController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var savedPodcast = UserDefaults.standard.getSavedPodcast()
    fileprivate let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedPodcast = UserDefaults.standard.getSavedPodcast()
        collectionView?.reloadData()
        UIApplication.mainTabBar().viewControllers?[0].tabBarItem.badgeValue = nil
        
    }
    
    //MARK:- uicollectionview delegate / spacing 
    fileprivate func setCollectionView(){
        collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .white
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleDeletePodcast))
        collectionView.addGestureRecognizer(gesture)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPodcast.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoritePodcastCell
        cell.podcast = savedPodcast[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 16 * 3) / 2
        return CGSize(width: size, height: size + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodeVC = EpisodeTableViewController()
        episodeVC.podcast = self.savedPodcast[indexPath.item]
        navigationController?.pushViewController(episodeVC, animated: true)
    }
    
    //MARK:- gesture
    @objc fileprivate func handleDeletePodcast(gesture: UILongPressGestureRecognizer){
        let cgPoint = gesture.location(in: collectionView)
        guard let selectIndexPath = collectionView.indexPathForItem(at: cgPoint) else {return}
        
        let alertView = UIAlertController(title: "remove favorite cast?", message: nil, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (yes) in
            UserDefaults.standard.deleteSavedPodcast(podcast: self.savedPodcast[selectIndexPath.item])
            self.savedPodcast.remove(at: selectIndexPath.item)
            self.collectionView.deleteItems(at: [selectIndexPath])
            
        }))
        alertView.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        present(alertView, animated: true)
    }
}
