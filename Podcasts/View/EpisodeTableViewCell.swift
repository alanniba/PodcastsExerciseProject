//
//  EpisodeTableViewCell.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/6.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import SDWebImage
class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeImageV: UIImageView!
    @IBOutlet weak var pubDateLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var descriptionLab: UILabel!
    @IBOutlet weak var progressLab: UILabel!
    
    var episode : Episode!{
        didSet{
            self.titleLab.text = episode.title ?? ""
            self.descriptionLab.text = episode.description ?? ""
            self.pubDateLab.text = self.dataFormatter(date: episode.pubDate)
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            self.episodeImageV.sd_setImage(with: url)
        }
    }
    
    func dataFormatter (date : Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let resultDate = dateformatter.string(from: date)
        return resultDate
    }
}
