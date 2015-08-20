//
//  TopicDetailsCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class TopicDetailsCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var collect: UIButton!
    
    @IBOutlet weak var tags: UIButton!
    
    
    var topicModel: TopicDetails? {
        didSet {
            
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (topicModel!.image))
            self.imageView?.sd_setImageWithURL(imageURL)
//            self.imageView?.clipsToBounds = true
            self.title.text = topicModel!.title
            self.subtitle.text = topicModel!.subtitle
            self.desc.text = topicModel!.desc
            self.collect.setTitle(topicModel!.collect, forState: UIControlState.Normal)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView?.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
