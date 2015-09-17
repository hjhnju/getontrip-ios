//
//  LandscapeCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class LandscapeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var landImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor    = SceneColor.white
        titleLabel.textColor    = SceneColor.black
        self.layer.cornerRadius = 2
        landImageView.layer.cornerRadius = 2
        landImageView.clipsToBounds = true
        landImageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func setDisplayFields(landscape: Landscape) {
        var title = "\(landscape.name)"
        if let dis = landscape.distance {
            title = title + " \(dis)"
        }
        titleLabel.text = title
        if let imageUrl = landscape.imageUrl {
            if let url = NSURL(string: imageUrl) {
                landImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-topic"))
            }
        }
    }
    
    
}
