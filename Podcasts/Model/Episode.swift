//
//  Episode.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/5.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import Foundation
import FeedKit
struct Episode : Codable {
    var title : String?
    var pubDate : Date
    var description: String?
    var imageUrl : String?
    var artist : String?
    var playUrl : String
    var fileUrl : String?
    init(feedItem : RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.artist = feedItem.iTunes?.iTunesAuthor ?? ""
        self.playUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
