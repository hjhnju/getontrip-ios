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
    @IBOutlet var distance: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet weak var sightLabel: UILabel!
    
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
            }
        }
    }
    
    override func awakeFromNib() {
        self.sightLabel.layer.cornerRadius = 10
        self.sightLabel.layer.borderWidth = 2
        self.sightLabel.layer.masksToBounds = true
        self.sightLabel.layer.borderColor = UIColor.yellowColor() as! CGColorRef
    }

    
    var distanceValue:String? {
        didSet {
            if let value = distanceValue {
                self.distance.text = value
            }
        }
    }
    var cityValue:String? {
        didSet {
            if let value = cityValue {
                self.city.text = value
            }
        }
    }
    var descValue:String? {
        didSet {
            if let value = descValue {
                self.desc.text = value
            }
        }
    }
}
