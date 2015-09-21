//
//  SightHeaderView.swift
//  Smashtag
//
//  Created by 何俊华 on 15/7/23.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SightHeaderViewCell: UITableViewCell {
    
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet weak var sightLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sightId: UIButton!
    
    @IBOutlet weak var tocityButton: UIButton!
    var sightImageUrl:String? {
        didSet{
            if let sightImageUrl = sightImageUrl{
                if let url = NSURL(string: sightImageUrl) {
                    self.headerImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-sight"))
                }
            }
        }
    }
    
    var sightName:String? {
        didSet {
            if let name = sightName {
                sightLabel.text = name
                sightLabel.resizeWidthToFit(self.widthConstraint)
                //width最小不小于57
                self.widthConstraint.constant = max(self.widthConstraint.constant + 20, 57)
            }
        }
    }
    
    var distanceValue:String? {
        didSet {
            if let value = distanceValue {
                self.distanceLabel.text = value
            }
        }
    }
    
    var cityValue:String? {
        didSet {
            if let value = cityValue {
                self.cityLabel.text = value
            }
        }
    }
    
    var descValue:String? {
        didSet {
            if let value = descValue {
                self.descLabel.attributedText = value.getAttributedString(1.1)
            }
        }
    }
    
    // MARK: View Life Circle
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        
        sightLabel.layer.cornerRadius = 10
        sightLabel.layer.borderWidth = CGFloat(2)
        sightLabel.layer.masksToBounds = true
        sightLabel.layer.borderColor = UIColor.yellowColor().CGColor
        
        sightLabel.font = UIFont(name: SceneFont.heiti, size: 14)
        
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        
    }
    
    func updateCell(sight: Sight){
        self.sightName     = sight.name
        self.sightImageUrl = sight.image
        self.distanceValue = sight.dis
        self.cityValue     = sight.city
        self.descValue     = sight.describe
        self.sightId.tag   = Int(sight.id!)
        self.sightId.setTitle(sight.name, forState: UIControlState.Normal)
        tocityButton.titleLabel?.text = self.sightId.titleLabel?.text
        tocityButton.tag = sightId.tag
    }
}
