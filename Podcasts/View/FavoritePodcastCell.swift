//
//  FavoritePodcastCell.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/21.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import SDWebImage
class FavoritePodcastCell: UICollectionViewCell {
    
    
    var podcast : Podcast!{
        didSet{
            
            if let url = URL(string: podcast.artworkUrl100 ?? "") {
                imageView.sd_setImage(with: url)
            }
            nameLab.text = podcast.trackName ?? ""
            artistNameLab.text = podcast.artistName ?? ""
        }
    }
    let imageView = UIImageView(image: UIImage(named: "downloads"))
    let nameLab = UILabel()
    let artistNameLab = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylingUI()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- setup styling of ui and constraints
    fileprivate func stylingUI() {
        nameLab.text = "podcast name"
        nameLab.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistNameLab.text = "artist name"
        artistNameLab.font = UIFont.systemFont(ofSize: 14)
        artistNameLab.tintColor = UIColor.darkGray
        imageView.contentMode = .scaleAspectFill
    }
    
    fileprivate func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView , nameLab , artistNameLab])
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
    }
}
