//
//  NearbyTableViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class NearbyTableViewCell: UITableViewCell {

    // MASK: Outlets

    @IBOutlet weak var topicImageView: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var visitsLabel: UILabel!
    
    @IBOutlet var favoritesLabel: UILabel!
    
    var topicImageUrl:String? {
        didSet{
            if let topicImageUrl = topicImageUrl {
                if let url = NSURL(string: topicImageUrl) {
                    self.topicImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-topic"))
                }
            }
        }
    }
    
    var title:String? {
        didSet {
            if let newValue = title?.trim() {
                self.titleLabel.attributedText = newValue.getAttributedString(lineSpacing: 4)
            }
        }
    }
    
    var subtitle:String? {
        didSet {
            if let newTitle = subtitle?.trim() {
                self.subtitleLabel.text = newTitle
            }
        }
    }
    
    var favorites:String? {
        didSet {
            if let newFavorites = favorites {
                self.favoritesLabel.text = newFavorites
            }
        }
    }
    
    var desc:String? {
        didSet {
            if let newValue = desc?.trim() {
                self.descLabel.attributedText = newValue.getAttributedString(lineSpacing: 4)
            }
        }
    }
    
//    var visits:Int? {
//        didSet {
//            if let newValue = visits {
//                self.visitsLabel.text = "\(newValue)"
//            }
//        }
//    }
    
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        
        //设置字体和颜色
        subtitleLabel.textColor  = SceneColor.lightGray
        titleLabel.textColor     = SceneColor.white
        descLabel.textColor      = SceneColor.lightGray
        favoritesLabel.textColor = SceneColor.lightGray
        visitsLabel.textColor    = SceneColor.crystalWhite
        
        subtitleLabel.font = UIFont(name: SceneFont.heiti, size: 9)
        titleLabel.font    = UIFont(name: SceneFont.heiti, size: 14)
        descLabel.font     = UIFont(name: SceneFont.heiti, size: 10)
        
        topicImageView.contentMode   = UIViewContentMode.ScaleAspectFill
        topicImageView.clipsToBounds = true
        
    }
    
    func updateCell(topic: Topic){
        self.topicImageUrl = topic.image
        self.subtitle      = topic.subtitle
        self.title         = topic.title
        self.favorites     = topic.collect
        self.desc          = topic.desc
//        self.visits        = topic.visits
    }
    
}
