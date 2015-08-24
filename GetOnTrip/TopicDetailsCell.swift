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
    
    @IBOutlet weak var label1: UIButton!
    
    @IBOutlet weak var label2: UIButton!
    
    @IBOutlet weak var label3: UIButton!
    
    @IBOutlet weak var label4: UIButton!
    
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
            
            // TODO:  添加标签
            for (var i: NSInteger = 0; i < topicModel?.tags.count; i++ ) {
                if (i == 0){
                    label1.hidden = false
                    label1.setTitle(topicModel!.tags[i] as? String, forState: UIControlState.Normal)
                } else if(i == 1){
                    label2.hidden = false
                    label2.setTitle(topicModel!.tags[i] as? String, forState: UIControlState.Normal)
                } else if (i == 2){
                    label3.hidden = false
                    label3.setTitle(topicModel!.tags[i] as? String, forState: UIControlState.Normal)
                } else if(i == 3){
                    label4.hidden = false
                    label4.setTitle(topicModel!.tags[i] as? String, forState: UIControlState.Normal)
                }
                
            }
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
