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
    
    var topicModel: TopicDetails? {
        didSet {
            
            var imageURL = NSURL(string: AppIniOnline.BaseUri + (topicModel!.image))
            self.iconImage?.sd_setImageWithURL(imageURL)
            self.title.text = topicModel!.title
            self.subtitle.text = topicModel!.subtitle
            self.desc.text = topicModel!.desc
            self.collect.setTitle(" " + topicModel!.collect, forState: UIControlState.Normal)
            self.collect.setImage(UIImage(named: "collect"), forState: UIControlState.Normal)
            self.bringSubviewToFront(self.collect)
            self.collect.userInteractionEnabled = false
            self.imageView?.contentMode = UIViewContentMode.ScaleToFill
            
            // TODO: 待定 添加标签 
//            let x: CGFloat = CGRectGetMaxX(iconImage.frame) + 7
//            let y: CGFloat = CGRectGetMaxY(desc.frame) + 6
//            let w: CGFloat = 28
//            let h: CGFloat = 10
//            for label_text in topicModel!.tags {
//                let labelBtn = UIButton()
//                label1.setTitle(label_text as? String, forState: UIControlState.Normal)
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView?.clipsToBounds = true
        collect.setTitleColor(SceneColor.lightGray, forState: UIControlState.Normal)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
