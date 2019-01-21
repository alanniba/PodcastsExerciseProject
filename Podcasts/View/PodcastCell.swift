//
//  PodcastCell.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/4.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import SDWebImage
class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackNameLab: UILabel!
    @IBOutlet weak var artistNameLab: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    var podcast : Podcast!{
        didSet{
            trackNameLab.text = podcast.trackName
            artistNameLab.text = podcast.artistName
            episodeCount.text = "\(podcast.trackCount ?? 0)"
            guard let url = URL(string: podcast.artworkUrl100 ?? "") else {
                print("something wrong with image url")
                return
            }
            podcastImage.sd_setImage(with: url, completed: nil)
        }
    }
}

