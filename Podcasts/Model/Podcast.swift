//
//  Podcast.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/4.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import Foundation
class Podcast :NSObject, Decodable , NSCoding {
    func encode(with aCoder: NSCoder) {
        print("Trying to transform Podcast into data")
        aCoder.encode(trackName ?? "", forKey: "trackName")
        aCoder.encode(artistName ?? "", forKey: "artistName")
        aCoder.encode(artworkUrl100 ?? "", forKey: "artworkUrl100")
        aCoder.encode(feedUrl ?? "" , forKey: "feedUrl")

    }
    
    required init?(coder aDecoder: NSCoder) {
        print("Trying to turn data into podcast")
        self.trackName = aDecoder.decodeObject(forKey: "trackName") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl100 = aDecoder.decodeObject(forKey: "artworkUrl100") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedUrl") as? String

    }
    
    var trackName : String?
    var artistName : String?
    var trackCount : Int?
    var artworkUrl100 : String?
    var feedUrl : String?
    
}

