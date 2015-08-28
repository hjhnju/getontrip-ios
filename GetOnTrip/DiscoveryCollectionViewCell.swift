//
//  DiscoveryCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class DiscoveryCollectionViewCell: UICollectionViewCell {
    
    var topic: Topic?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locateLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor         = SceneColor.white
        locateLabel.textColor        = SceneColor.white
        imageView.backgroundColor    = SceneColor.crystalWhite
        imageView.contentMode        = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds      = true
        imageView.layer.cornerRadius = 3
        self.layer.cornerRadius      = 3
    }
    
    func setDisplayFields(topic: Topic) {
        self.titleLabel.text = topic.title
        if let imageUrl = topic.imageUrl {
            if let url = NSURL(string: imageUrl) {
                self.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-topic"))
            }
        }
        let city = topic.city ?? ""
        let sight = topic.sight ?? ""
        let distance = topic.distance ?? ""
        var locate = ""
        if !city.isEmpty {
            locate = "\(city)·"
        }
        locate = locate + "\(sight) \(distance)"
        self.locateLabel.text = locate
        self.favoritesLabel.text = "\(topic.favorites ?? 0)"
        self.commentsLabel.text = "\(topic.commentCount ?? 0)"
        //NSLog("DiscoveryCollectionViewCell.awakeFromNib:frame=\(self.frame)")
    }
}
