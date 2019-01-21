//
//  RSSFeed.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/6.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import FeedKit

extension RSSFeed{
    func toEpisode () -> [Episode]{
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        
        items?.forEach({ (item) in
            
            var episode = Episode(feedItem: item)
            if episode.imageUrl == nil{
                episode.imageUrl = imageUrl!
            }
            episodes.append(episode)
        })
        return episodes
    }
}

