//
//  ThemeTableViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        
        themeImageView.layer.cornerRadius = 2
        themeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        themeImageView.clipsToBounds = true
        
        titleLabel.textColor = SceneColor.white
        favoritesLabel.textColor = SceneColor.white
        periodLabel.textColor = SceneColor.white
        
        titleLabel.font = UIFont(name: SceneFont.heiti, size: 24)
        periodLabel.font = UIFont(name: SceneFont.heiti, size: 14)
        favoritesLabel.font = UIFont(name: SceneFont.heiti, size: 9)
    }
    
    func updateCell(theme: Theme){
        if let url = NSURL(string: theme.imageUrl) {
            themeImageView?.sd_setImageWithURL(url, placeholderImage: UIImage(named:"default-theme"))
        }
        
        titleLabel.text   = theme.title
        periodLabel.text  = theme.period
        favoritesLabel.text = "\(theme.favorites)"
    }
}
