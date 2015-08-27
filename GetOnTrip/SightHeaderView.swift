//
//  SightHeaderView.swift
//  Smashtag
//
//  Created by 何俊华 on 15/7/23.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SightHeaderView: UITableViewCell {
    
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet weak var sightLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sightId: UIButton!
    
    var sightImage:UIImage? {
        didSet {
            self.headerImageView!.image = self.sightImage
        }
    }
    
    var sightImageUrl:String? {
        didSet{
            if let url = sightImageUrl{
                if url != "" {
                    ImageLoader.sharedLoader.imageForUrl(url) { (image:UIImage?, url:String) in
                        self.sightImage = image
                    }
                } 
            }
            if self.sightImage == nil {
                self.sightImage = UIImage(named: "default-sight")
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
                self.descLabel.attributedText = value.getAttributedString(lineHeightMultiple: 1.1)
            }
        }
    }
    
    // MARK: View Life Circle
    
    override func awakeFromNib() {
        sightLabel.layer.cornerRadius = 10
        sightLabel.layer.borderWidth = CGFloat(2)
        sightLabel.layer.masksToBounds = true
        sightLabel.layer.borderColor = UIColor.yellowColor() as! CGColorRef
        
        sightLabel.font = UIFont(name: SceneFont.heiti, size: 14)
        
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        
    }
}
