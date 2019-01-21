//
//  Userdefult.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/23.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import Foundation
extension UserDefaults{
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadEpisodeKey = "downloadEpisodeKey"

    func downloadEpidose(episode : Episode){

        do{
            var downloadedEpisode = getDownloadEpisode()
//            downloadedEpisode.append(episode)
            downloadedEpisode.insert(episode, at: 0)
            let data = try JSONEncoder().encode(downloadedEpisode)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)
        } catch let error {
            print("unable to encode episode ", error)
        }
    }
    
    func getDownloadEpisode() -> [Episode]{
        guard let epidosdData = UserDefaults.standard.data(forKey: UserDefaults.downloadEpisodeKey) else {return []}
        do{
            let episodeArray = try JSONDecoder().decode([Episode].self, from: epidosdData )
            return episodeArray

        } catch let error{
            print("faild decode",error)
        }
        return []
    }
    
    func deleteDownloadEpisode(episode: Episode){
        let episodes = getDownloadEpisode()
        let filterdEpisode = episodes.filter { (p) -> Bool in
            return p.title != episode.title
        }
        do{
            let data = try JSONEncoder().encode(filterdEpisode)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)
        } catch let error{
            print(error)
        }
    }
    
    func getSavedPodcast() -> [Podcast]{
        
        guard let currentPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else {return []}
        guard let currentPodcast = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(currentPodcastData) as? [Podcast] else {return []}
        return currentPodcast
    }
    
    func deleteSavedPodcast(podcast : Podcast){
        let podcasts = getSavedPodcast()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        } catch let error{
            print("cannot delete object ", error)
        }
    }
}
